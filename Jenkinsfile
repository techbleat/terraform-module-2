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
            environment {
                NGINX_NODE = sh(script: "cd dev ;terraform output  |  grep nginx | cut -c 11-60",returnStdout: true).trim()
                BNGINX_NODE = 'ec2-18-175-133-113.eu-west-2.compute.amazonaws.com'
            }
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        env
                        cd dev
                        echo `terraform output  | grep nginx  | awk -F\\" '{print \$2}'`
                        ssh  ${NGINX_NODE} 'pwd'
                       
                        """
                        
                    }
                }
            }
        }     
    }
}