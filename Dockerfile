# Java 21 LTS JDK가 포함된 공식 경량화(Alpine Linux) 이미지를 기반으로 설정
FROM eclipse-temurin:21-jdk-alpine

# 컨테이너 내부에 임시 파일 저장 공간으로 /tmp 디렉터리를 볼륨으로 지정
# (Spring Boot 내장 톰캣이 작업 공간으로 /tmp를 사용하므로 성능 및 관리에 유용)
VOLUME /tmp

# 빌드 결과물인 JAR 파일 중 plain.jar를 제외한 생성된 app.jar 파일(또는 단일 jar)을 컨테이너 내부의 app.jar로 복사
# (# -plain.jar 생성을 막았으므로 build/libs/*.jar 로 깔끔하게 지정 가능)
COPY build/libs/*-SNAPSHOT.jar app.jar

# 컨테이너가 8080번 포트를 사용할 것임을 명시 (Spring Boot 기본 포트 / 문서화 용도)
EXPOSE 8080

# 컨테이너가 시작될 때 실행할 기본 명령어를 지정 (java -jar /app.jar 실행)
ENTRYPOINT ["java","-jar","/app.jar"]