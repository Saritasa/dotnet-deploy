pipeline {
    agent any

    environment {
        SecretConfigPath = credentials("${env.SecretConfig}")
    }

    stages {
        stage ('SCM') {
            steps {
                script {
                    checkout scm

                    sh script: 'psake clean'
                }
            }
        }

        stage ('Publish Web') {
            steps {
                script {
                    sshagent(['deployuser']) {
                        sh script: "psake publish-web"
                    }
                }
            }
        }
    }
}