pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mule-api"
        DOCKER_CONTAINER_NAME = "mule-runtime"
        MULE_DOCKER_IMAGE = "mule-runtime:4.5.0" // Replace with your Mule runtime Docker image
        LOCAL_DEPLOY_PATH = "/opt/mule/apps" // Default Mule apps deployment path
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out the code from the branch..."
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building the Mule application..."
                sh 'mvn clean package -DskipTests' // Use Maven Wrapper or mvn if installed globally
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building a Docker image for the Mule API..."
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                    """
                }
            }
        }

        stage('Docker Run') {
            steps {
                echo "Deploying the Mule API on a local Docker Mule runtime..."
                script {
                    // Stop and remove the existing container if it exists
                    sh """
                        docker stop ${DOCKER_CONTAINER_NAME} || true
                        docker rm ${DOCKER_CONTAINER_NAME} || true
                    """
                    
                    // Run the Mule runtime container
                    sh """
                        docker run -d \
                            --name ${DOCKER_CONTAINER_NAME} \
                            -v ${env.WORKSPACE}/target:/opt/mule/apps \
                            -p 8081:8081 \
                            -p 7777:7777 \
                            ${MULE_DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Verifying Mule application deployment..."
                script {
                    sh "docker logs -f ${DOCKER_CONTAINER_NAME}"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }

        success {
            echo "Mule API deployed successfully!"
        }

        failure {
            echo "Mule API deployment failed!"
        }
    }
}
