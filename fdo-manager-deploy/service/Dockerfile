FROM eclipse-temurin:21-jre-alpine
RUN mkdir /opt/app

ARG SERVICE_VERSION=0.1.0-SNAPSHOT
ARG PROJECT_ID=231
ARG PACKAGE_NAME=fdo-manager-service
ARG JAR_FILE=${PACKAGE_NAME}.${SERVICE_VERSION}.jar

ADD https://gitlab.indiscale.com/api/v4/projects/${PROJECT_ID}/packages/generic/${PACKAGE_NAME}/${SERVICE_VERSION}/${JAR_FILE} /opt/app/

EXPOSE 8080
ENV JAR_FILE=${JAR_FILE}
CMD java -jar /opt/app/${JAR_FILE}
