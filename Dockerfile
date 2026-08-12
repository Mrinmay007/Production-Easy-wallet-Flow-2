FROM tomcat:10.1-jdk1i7

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/Production-Easy-Wallet-Flow-2.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"


