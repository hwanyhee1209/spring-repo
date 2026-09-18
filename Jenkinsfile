pipeline {
    agent any
    stages {
        stage('Git Clone') {
            steps {
		            echo '1. 소스 코드 가져오는 중...'
                git branch: 'main', url: 'https://github.com/hwanyhee1209/spring-repo.git'
            }
        }
        stage('Build') {
            steps {
		        echo '2. 프로젝트 빌드 중...'
		        // 실행 권한 부여 추가
                sh 'chmod +x gradlew'
                //-x test :unit test(단위 테스트) 실행 단계를 제외(exclude)
                //빠른 빌드 및 배포를 위해 테스트를 스킵
                //빌드 서버(EC2) 환경에서 테스트용 DB나 외부 API 연동 환경이 구축되어 있지 않아 발생할 수 있는 빌드 실패를 방지
                //테스트는 실행하되 결과와 상관없이 빌드를 진행하고 싶은 경우
                //sh './gradlew clean build --continue'
                // -plain.jar 생성 방지 옵션(-x test와 함께 전달 가능) 및 빌드
                sh './gradlew clean build -x test -PplainJar.enabled=false'
            }
        }
        stage('Docker Build & Run') {
            steps {
		           // 젠킨스가 8080 사용.스프링 부트와 충돌 피하기 위해
		           // Docker 포트 포워딩(외부 포트) 변경
	             // 외부 포트를 8081로 변경 (-p 8081:8080)
	             // 도커 호스트 포트 : 컨테이너 내부 포트
	             // 젠킨스 접속: http://EC2_IP:8080
	             // 스프링 부트 접속: http://EC2_IP:8081
                echo '3. 도커 이미지 빌드 및 EC2 배포 중...'
                sh '''
                    # 1) 기존 실행 중인 컨테이너 중지 및 삭제
                    docker stop spring-app || true
                    docker rm spring-app || true

                    # 2) 도커 이미지 빌드
                    docker build -t spring-app .

                    # 3) 도커 컨테이너 실행 (젠킨스 포트 8080과 충돌을 피하기 위해 호스트 8081 포트 매핑)
                    # 젠킨스 접속: http://EC2_IP:8080 / 스프링부트 접속: http://EC2_IP:8081
                    docker run -d -p 8081:8080 --name spring-app spring-app

                    # 4) 미사용(Dangling) 도커 이미지 정리 (EC2 디스크 용량 관리)
                    docker image prune -f || true

                    echo '배포 완료!'
                '''
            }
        }
    }
    post {
        success {
            echo 'CI/CD 파이프라인이 성공적으로 완료되었습니다.'
        }
        failure {
            echo '파이프라인 실행 중 오류가 발생했습니다.'
        }
    }
}