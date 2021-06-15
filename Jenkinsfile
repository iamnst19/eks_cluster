pipeline {

   parameters {
    choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the eks cluster.')
	string(name: 'cluster', defaultValue : 'demo', description: "EKS cluster name;eg demo creates cluster named eks-demo.")
    choice(name: 'k8s_version', choices: '1.19\n1.18\n1.17', description: 'K8s version to install.')
    string(name: 'instance_type', defaultValue : 'm5.large', description: "k8s worker node instance type.")
    string(name: 'num_workers', defaultValue : '2', description: "k8s number of worker instances.")
    string(name: 'max_workers', defaultValue : '4', description: "k8s maximum number of worker instances that can be scaled.")
    string(name: 'region', defaultValue : 'us-east-1', description: "AWS region.")
  }
  
  agent any
  tools {
        terraform 'terraform-12' 
		git       'github'  
    }
  stages {
    stage('checkout') {
        steps {
            git 'https://github.com/iamnst19/Istio_EKS_Terraform.git'
        }
    }
	stage('Setup') {
		steps {
			script {
				currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + " eks-" + params.cluster
				plan = params.cluster + '.plan'
			}
		}
	}
    stage('Checking Terraform') {
        steps {
            sh 'terraform -version'
        }
    }
	
    stage('TF Plan') {
      when {
        expression { params.action == 'create' }
		}	
		steps {
			script {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
				sh """
					terraform init
					terraform plan \
						-var cluster-name=${params.cluster} \
						-out ${plan}
					echo ${params.cluster}
				"""
				}
			}
        }
      }

    stage('TF Apply') {
      when {
        expression { params.action == 'create' }
		}	
		steps {
			script {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
				if (fileExists('$HOME/.kube')) {
					echo '.kube Directory Exists'
				} else {
				sh 'mkdir -p $HOME/.kube'
				}
				sh """
					terraform apply -input=false -auto-approve ${plan}
					terraform output kubeconfig > /root/.kube/config
				"""
				sh 'sudo chown 0:0 /root/.kube/config'
				sleep 60
				sh 'kubectl get nodes'
				}
             }
        }
    }
	stage('Istio Install') {
	  steps{
		  script{
			  sh " istioctl install -f \"istio-operator.yaml\" --kubeconfig /root/.kube/config -y"
		  }
	  }
	}

    stage('TF Destroy') {
      when {
        expression { params.action == 'destroy' }
      }
      steps {
        script {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
				sh """
				terraform workspace select ${params.cluster}
				terraform destroy -auto-approve
				"""
				}
            }
        }
     }
  }
  post {
    success {
      mail to: "iamnst19@gmail.com", subject:"SUCCESS: ${currentBuild.fullDisplayName}", body: "Yay, the script was successfull."
    }
    failure {
      mail to: "iamnst19gmail.com", subject:"FAILURE: ${currentBuild.fullDisplayName}", body: "Boo, the script failed."
    }
  }
}