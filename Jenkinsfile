pipeline {
    agent any
    
    environment {
        DEPLOY = "false"
        registry = "vat-calculator"
        dockerImage = ""
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
              npm 'install'
              npm 'test'
           }
        }
        stage ('Docker Build') {
          steps {
            script {
              dockerImage = docker.build(registry)
              dockerImage.tag("${env.BUILD_NUMBER}")
            }
          }
        }
        stage('Scan Image') {
          steps {
            grypeScan scanDest: "docker:${registry}:${BUILD_NUMBER}", repName: 'scanResult.txt', autoInstall:true
          }
        }
        // stage('Build Webpack') {
        //     steps {
        //         npm 'run build'
        //     }
        // }
        // stage('Archive') {
        //     steps {
        //       sh 'tar -czf build.tar.gz build'
        //       archiveArtifacts 'build.tar.gz'
        //     }
        // }
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
