pipeline {
    agent any 
    environment {
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
    }
    parameters {
        choice (choices: "ALL\nINFRA\nAPPS", description: " this is to manage pipeline steps", name: "DEPLOY_OPTIONS")
    }
    stages {
        stage('Initialise terraform') {
            steps {
                script {
                    echo "${params.DEPLOY_OPTIONS}"
                }
                sh '''
                cd dev
                terraform init
                '''
            }
        }
        stage('Terraform Plan ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=nginx' -var 'node2=python-node'
                '''
            }
        }  
        stage('Terraform Apply ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform apply -var 'node1=nginx' -var 'node2=python-node' -auto-approve
                '''
            }
        }
        stage ('Manage Apps') {

            when {
                expression  { params.DEPLOY_OPTIONS == 'APPS' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            environment {
                NGINX_NODE = sh(script: "cd dev; terraform output  |  grep nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
                PYTHON_NODE = sh(script: "cd dev; terraform output  |  grep python | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
            }
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        env
                        cd dev
                        ssh  -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} 'sudo yum install nginx -y && sudo service nginx start'
                        scp  -r -o StrictHostKeyChecking=no ../code ec2-user@${PYTHON_NODE}:/tmp
                        ssh  -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo yum install python3 -y; sudo cp /tmp/code/python.service /etc/systemd/system; sudo systemctl daemon-reload; sudo systemctl restart python.service'
                       
                        """
                        
                    }
                }
            }
        }

        stage ('Notification') {
            steps {
                script {
                    withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_ID')]) {

                        sh """
                          curl -X POST \
                          -H 'Authorization: Bearer ${SLACK_ID}' \
                          -H 'Content-Type: application/json' \
                          --data '{"channel": "devops-masterclass-2024","text" : "Hello, testing"}'  \
                          https://slack.com//api/chat.postMessage 
                        """
                    }
                }
            }
        }     
    }
    post {
        success {
            echo  "pipeline has succeeded"
        }
        failure  {
            echo  "pipeline has succeeded"
        }
        always {
            echo "always execute"
        }
        
    }
}
