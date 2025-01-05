pipeline {
    agent { label "dhruv" }

    stages {
        stage('Cloning') {
            steps {
                git url: "https://github.com/singhaldhruv/django-notes.git", branch: "main" 
                echo "Code Cloned Successfully"
            }
        }

        stage('Check and Install Docker') {
            steps {
                script {
                    if (sh(script: "which docker || echo 'not found'", returnStdout: true).trim() == "not found") {
                        echo "Docker is not installed. Installing Docker..."
                        sh """
                        sudo apt-get update
                        sudo apt-get install -y docker.io
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        """
                        echo "Docker installed successfully."
                    } else {
                        echo "Docker is already installed."
                    }
                }
            }
        }
        
        stage('Building Image') {
            steps {
                sh "docker build -t my-note-app ."
                echo "Image built successfully"
            }
        }
        
        stage("Push to Docker Hub"){
            steps{
                echo "Pushing the image to docker hub"
                withCredentials([usernamePassword(credentialsId:"Jenkins-Pipeline-Practice",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                sh "docker tag my-note-app ${env.dockerHubUser}/my-note-app:latest"
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                sh "docker push ${env.dockerHubUser}/my-note-app:latest"
                }
            }
        }
        
        stage('Deploy'){
            steps{
                sh "docker-compose down && docker-compose up -d"
                echo "This is deploying the code"
            }
        }
    }
}
