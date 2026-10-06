# Alpine 대신 Debian/Ubuntu 기반의 Temurin JDK 21 이미지 사용
FROM eclipse-temurin:21-jdk
VOLUME /tmp
COPY build/libs/*SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]