pipeline {
    agent any
    
    environment {
        DEPLOY = "false"
    }

    stages {
        // stage('Checkout'){
        //     steps {
        //       git url: 'https://github.com/agray998/vat-calculator-qaj.git',
        //           branch: 'main'
        //     }
        // }
        stage('Run Tests') {
            steps {
              sh 'npm install'
              sh 'CI=true npm test'
           }
        }
        stage('Build Webpack') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Archive') {
            steps {
              sh 'tar -czf build.tar.gz build'
              archiveArtifacts 'build.tar.gz'
            }
        }
        stage('Deploy') {
            when {
                environment name: "DEPLOY", value: "true"
            }
            steps {
                sh "echo Deploying..."
                sh "sleep 10"
            }
        }
    }
}
