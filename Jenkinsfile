pipeline {
    agent any 
    environment {
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
    }
    stages {
        stage('Initialise terraform') {
            steps {
                sh '''
                cd dev
                terraform init
                '''
            }
        }
        stage('Terraform Plan ') {
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=nginx' -var 'node2=python-node'
                '''
            }
        }  
        stage('Terraform Apply ') {
            steps {
                sh '''
                cd dev
                terraform apply -var 'node1=nginx' -var 'node2=python-node' -auto-approve
                '''
            }
        }
        stage ('Manage Nginx') {
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@ec2-18-175-133-113.eu-west-2.compute.amazonaws.com 'pwd'
                        """
                        
                    }
                }
            }
        }     
    }
}