pipeline {
    agent {
        node {
            label ''
            customWorkspace 'C:\\JenkinsWorkspace\\devops-project'
        }
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }

        stage('Get EC2 IP') {
            steps {
                bat 'terraform output -raw public_ip > ip.txt'
            }
        }

        stage('Deploy to EC2') {
            steps {
                bat '''
                set /p IP=<ip.txt
                echo EC2 IP is %IP%

                scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i jenkins-key deploy.sh ubuntu@%IP%:/home/ubuntu/
                scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i jenkins-key Dockerfile ubuntu@%IP%:/home/ubuntu/
                scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i jenkins-key index.html ubuntu@%IP%:/home/ubuntu/

                ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i jenkins-key ubuntu@%IP% "chmod +x deploy.sh && ./deploy.sh"
                '''
            }
        }
    }
}