FROM tomcat:9.0.70-jre11-temurin-jammy
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY ./webapp/target/*.war /usr/local/tomcat/webapps
