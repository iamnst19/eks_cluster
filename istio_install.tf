resource "time_sleep" "wait_90_seconds" {
  depends_on =  [null_resource.kube_config_import]

  create_duration = "90s"
}

resource "null_resource" "install_istio" {
  provisioner "local-exec" {
    command = "istioctl install -f \"istio-operator.yaml\" --kubeconfig /root/.kube/config -y"
  }
  depends_on = [  
      time_sleep.wait_90_seconds,
      aws_eks_cluster.demo,
      aws_eks_node_group.demo
  ]
}