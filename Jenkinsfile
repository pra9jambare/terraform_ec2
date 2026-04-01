pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
        SECRET_NAME = 'jenkins/terraform/aws'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/pra9jambare/terraform_ec2'
            }
        }

        stage('Verify Files') {
            steps {
                sh 'pwd'
                sh 'ls -l'
            }
        }

        stage('Fetch AWS Credentials from Secrets Manager') {
            steps {
                script {
                    def secret = sh(
                        script: """
                        aws secretsmanager get-secret-value \
                        --secret-id $SECRET_NAME \
                        --query SecretString \
                        --output text
                        """,
                        returnStdout: true
                    ).trim()

                    def json = readJSON text: secret

                    env.AWS_ACCESS_KEY_ID = json.access_key
                    env.AWS_SECRET_ACCESS_KEY = json.secret_key
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                terraform plan
                '''
            }
        }

        stage('Approval') {
            steps {
                input message: 'Do you want to apply Terraform changes?'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                terraform apply -auto-approve
                '''
            }
        }

        stage('Terraform Output') {
            steps {
                sh 'terraform output'
            }
        }
    }

    post {
        success {
            echo '✅ EC2 Instance Created Successfully!'
        }
        failure {
            echo '❌ Pipeline Failed!'
        }
    }
}
