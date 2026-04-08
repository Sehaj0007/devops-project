pipeline {
    agent any

    stages {

        stage('Clone Repo') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t nextread-app .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker stop nextread || true'
                sh 'docker rm nextread || true'
                sh 'docker run -d -p 8081:80 --name nextread nextread-app'
            }
        }
    }
}