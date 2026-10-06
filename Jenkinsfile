pipeline {
    agent any

    environment {
        // Docker Hub 계정 정보 및 이미지 설정
        DOCKER_HUB_REPO = 'bilbadarryl081/spring-kubernetes-app'
        IMAGE_TAG       = "${BUILD_NUMBER}"             // Jenkins 내장 빌드 번호
        REGISTRY_CREDS  = 'docker-hub-auth'     // Jenkins Credentials ID
    }

    stages {
        stage('Git Clone') {
            steps {
                echo '1. 소스 코드 가져오는 중...'
                git branch: 'main', url: 'https://github.com/hwanyhee1209/spring-kubernetes-app.git'
            }
        }

        stage('Build Application') {
            steps {
                echo '2. 프로젝트 빌드 중...'
                sh 'chmod +x gradlew'
                // plain jar 생성 방지 및 단위 테스트 스킵 빌드
                sh './gradlew clean build -x test -PplainJar.enabled=false'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '3. 도커 이미지 빌드 중...'
                // 프로젝트 루트의 Dockerfile을 기반으로 이미지 빌드
                sh """
                    docker build -t ${DOCKER_HUB_REPO}:${IMAGE_TAG} .
                    docker build -t ${DOCKER_HUB_REPO}:latest .
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '4. 도커 허브 로그인 및 이미지 푸시 중...'
                // withCredentials를 사용해 Docker Hub 로그인 및 푸시
                // usernameVariable: 'DOCKER_USER' : 찾아온 자격 증명의 사용자명(Username)을 DOCKER_USER라는 변수 이름으로 주입
                // passwordVariable: 'DOCKER_PASS' : 찾아온 자격 증명의 비밀번호/토큰(Password)을 DOCKER_PASS라는 변수 이름으로 주입
                // 즉, 파이프라인 블록이 실행되는 동안만 해당 변수들에 실제 데이터가 담겨 전달된다
                withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                        docker push ${DOCKER_HUB_REPO}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            echo '5. Docker 로그인 정보 및 로컬 이미지 정리 작업 수행 중...'
            sh 'docker logout'
            sh "docker rmi ${DOCKER_HUB_REPO}:${IMAGE_TAG} || true"
            sh "docker rmi ${DOCKER_HUB_REPO}:latest || true"
        }
    }
}