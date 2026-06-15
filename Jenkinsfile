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
                sh """
                docker rm -f vat-calculator || docker ps
                docker run -d -p 3000:3000 --name vat-calculator ${registry}:${env.BUILD_NUMBER}
                docker inspect vat-calculator
                """
            }
        }
    }
    post {
        always {
            recordIssues(
                qualityGates: [
                    [criticality: 'FAILURE', integerThreshold: 30, threshold: 30.0, type: 'TOTAL_HIGH'], 
                    [criticality: 'FAILURE', integerThreshold: 5, threshold: 5.0, type: 'NEW']
                    ], 
                    sourceCodeRetention: 'LAST_BUILD', 
                    tools: [grype()]
            )
        }
    }
}
