FROM gradle:8.2.1-jdk17 AS builder

WORKDIR /usr/src

COPY . .

RUN echo "systemProp.http.proxyHost=krmp-proxy.9rum.cc\nsystemProp.http.proxyPort=3128\nsystemProp.https.proxyHost=krmp-proxy.9rum.cc\nsystemProp.https.proxyPort=3128" > /root/.gradle/gradle.properties

RUN gradle wrapper --gradle-version 8.2.1
RUN chmod +x gradlew
RUN ./gradlew clean build -x test

FROM openjdk:17-jdk-alpine
COPY --from=builder /usr/src/build/libs/startup-valley-0.0.1-SNAPSHOT.jar /usr/app/app.jar
ENTRYPOINT ["java","-jar","/usr/app/app.jar"]