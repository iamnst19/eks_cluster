pipeline {

   parameters {
    choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the eks cluster.')
    string(name: 'cluster', defaultValue : 'demo', description: "EKS cluster name;eg demo creates cluster named eks-demo.")
    choice(name: 'k8s_version', choices: '1.17\n1.18\n1.16', description: 'K8s version to install.')
    string(name: 'num_subnets', defaultValue : '3', description: "Number of vpc subnets/AZs.")
    string(name: 'instance_type', defaultValue : 'm5.large', description: "k8s worker node instance type.")
    string(name: 'num_workers', defaultValue : '3', description: "k8s number of worker instances.")
    string(name: 'max_workers', defaultValue : '10', description: "k8s maximum number of worker instances that can be scaled.")
    string(name: 'credential', defaultValue : 'jenkins', description: "Jenkins credential that provides the AWS access key and secret.")
    string(name: 'key_pair', defaultValue : 'spicysomtam-aws4', description: "EC2 instance ssh keypair.")
    string(name: 'region', defaultValue : 'eu-west-1', description: "AWS region.")
  }

  options {
    disableConcurrentBuilds()
    timeout(time: 1, unit: 'HOURS')
    withAWS(credentials: params.credential, region: params.region)
    ansiColor('xterm')
  }

  agent { label 'master' }

  stages {

    stage('Setup') {
      steps {
        script {
          currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + " eks-" + params.cluster
          plan = params.cluster + '.plan'
        }
      }
    }

    stage('TF Plan') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
          credentialsId: params.credential, 
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
              // Format cidrs into a list array

            sh """
              terraform init
              terraform workspace new ${params.cluster} || true
              terraform workspace select ${params.cluster}
              terraform plan \
                -var cluster-name=${params.cluster} \
                -var vpc-network=${params.vpc_network} \
                -var vpc-subnets=${params.num_subnets} \
                -var inst-type=${params.instance_type} \
                -var num-workers=${params.num_workers} \
                -var max-workers=${params.max_workers} \
                -var inst_key_pair=${params.key_pair} \
                -var ca=${params.ca} \
                -var k8s_version=${params.k8s_version} \
                -var aws_region=${params.region} \
                -out ${plan}
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
          input "Create/update Terraform stack eks-${params.cluster} in aws?" 

          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
          credentialsId: params.credential, 
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            
            sh """
              terraform apply -input=false -auto-approve ${plan}
            """
          }
        }
      }
    }

    stage('Cluster setup') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
          credentialsId: params.credential, 
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            
            sh """
              aws eks update-kubeconfig --name eks-${params.cluster} --region ${params.region}
              # Add configmap aws-auth if its not there:
              if [ ! "\$(kubectl -n kube-system get cm aws-auth 2> /dev/null)" ]
              then
                echo "Adding aws-auth configmap to ns kube-system..."
                terraform output config_map_aws_auth | awk '!/^\$/' | kubectl apply -f -
              else
                true # jenkins likes happy endings!
              fi
            """

            // If admin_users specified


            if (params.ca == true) {
              echo "Setting up k8s Cluster Autoscaler."

              // Keep the google region logic simple; us or eu
              gregion='us'

              if (params.region =~ '^eu') {
                gregion='eu'
              }

              // CA image tag, which is k8s major version plus CA minor version.
              // See for latest versions: https://github.com/kubernetes/autoscaler/releases
              switch (params.k8s_version) {
                case '1.18':
                  tag='3'
                	break;
                case '1.17':
                  tag='4'
                	break;
                case '1.16':
                  tag='7'
              	  break;
              }
            }

            }
 
          }
        }
      }
    }

    stage('TF Destroy') {
      when {
        expression { params.action == 'destroy' }
      }
      steps {
        script {
          input "Destroy Terraform stack eks-${params.cluster} in aws?" 

          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
            credentialsId: params.credential, 
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',  
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {

            sh """
              terraform workspace select ${params.cluster}
              terraform destroy -auto-approve
            """
          }
        }
      }
    }

  }

}