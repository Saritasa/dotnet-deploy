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

                    bat script: 'psake clean'
                }
            }
        }

        stage ('Publish Service') {
            steps {
                script {
                    bat script: "psake publish-service"
                }
            }
        }
    }
}