pipeline {

    agent any

    tools {
        maven 'M3'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                    -Dsonar.projectKey=Production-Easy-wallet-Flow-2
                    '''
                }
            }
        }

        stage('Docker Deployment') {
            steps {
                sshagent(credentials: ['Jenkins-Docker-server-connection-Mrinamy']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no \
                        ec2-user@172.31.42.137 \
                        "mkdir -p /home/ec2-user/docker-build/target"

                        scp -o StrictHostKeyChecking=no \
                        Dockerfile \
                        ec2-user@172.31.42.137:/home/ec2-user/docker-build/

                        scp -o StrictHostKeyChecking=no \
                        target/Production-Easy-wallet-Flow-2.war \
                        ec2-user@172.31.42.137:/home/ec2-user/docker-build/target/

                        ssh -o StrictHostKeyChecking=no \
                        ec2-user@172.31.42.137 '
                            set -e
                            cd /home/ec2-user/docker-build

                            docker build \
                            -t production-easy-wallet-flow-2:1.0 .

                            docker rm -f easy-wallet-flow-2 2>/dev/null || true

                            docker run -d \
                            --name easy-wallet-flow-2 \
                            -p 9091:8080 \
                            production-easy-wallet-flow-2:1.0
                        '
                    '''
                }
            }
        }
    }
}
