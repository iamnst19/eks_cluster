resource "null_resource" "kube_config_import" {
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.istio-cluster.name}"
  }

  depends_on = [
      aws_eks_cluster.istio-cluster,
      aws_eks_node_group.demo
  ]
}
