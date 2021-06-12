## Cluster setup by Terraform

For the EKS Cluster setup we are using  terraform scripts to setup the cluster from scratch, the ‘.tf’ files for the same can be seen under the cluster folder 

Cluster creation was completed by setting up a simple EC2  bastion host with the following binaries installed as a prerequisite, they are:

### Prerequisite before Installing:

- aws cli

    - AWS CLI was there by defult in the EC2 machine used as a bastion; use the "aws configure" command to set the other values such as the 'AWS Access Key ID, AWS Secret Access Key, Default region name' required for the terraform script to run

    - Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

- terraform binaries

    - Reference: https://linoxide.com/install-terraform-provision-aws-ec2-instance/

- kubernetes client (kubectl)

    - Reference: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

- istio client (istioctl)

    - The Istio Client is used to install the profile inoperator ymal "istio-operator.yaml"

    - This will bring up the components such as ISTIOD, INGRESSGATEWAY and EGRESSGATEWAY kubernetes objects. 

    - Furthermore this client can be used as a client to interact with Istio for other operations in this project   such as for viewing the profile dump, injecting sidecar, producing manifests etc. or any other istio activites. 
	