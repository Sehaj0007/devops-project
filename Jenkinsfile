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
                bat 'docker build -t nextread-app .'
            }
        }

        stage('Run Container') {
            steps {
                bat 'docker stop nextread || exit 0'
                bat 'docker rm nextread || exit 0'
                bat 'docker run -d -p 8081:80 --name nextread nextread-app'
            }
        }
    }
}