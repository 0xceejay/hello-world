#!/usr/bin/env groovy

pipeline {
  agent any
  tools {
    maven 'maven'
  }
  environment {
    REPO = '0xceejay'
    IMAGE = 'hello-app'
  }

  stages {
    stage('Provision cluster') {
      steps {
        script {
          dir('terraform') {
            withCredentials([string(credentialsId: 'do-token', variable: 'token')]) {
              echo 'creating Digital Ocean Cluster'
              sh 'terraform init'
              sh "terraform apply -var 'do_token=${token}' --auto-approve"

              env.KUBECONFIG="kubeconfig.yaml"
              sh "kubectl get node"
            }
          }
        }
      }
    }

    stage('Build app') {
      steps {
        echo 'Building the application'
        sh 'mvn clean package'
      }
    }
  
    stage ('Build and Push image') {
      steps {
        echo 'building the image ...'
        withCredentials([usernamePassword(credentialsId: 'hub.docker', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
          sh "docker build -t ${REPO}/${IMAGE} ."
          sh "echo $PASS | docker login -u $USER --password-stdin"
          sh "docker push ${REPO}/${IMAGE}"
        }
      }
    }

    stage('Configure infrastructure') {
      steps {
        dir('ansible') {
          sh 'ansible-playbook play.yaml'
        }
      }
    }
  }
}
