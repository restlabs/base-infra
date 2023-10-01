resource "null_resource" "connect_eks_kube" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${local.cluster_name}"
  }

  depends_on = [
    aws_eks_cluster.my_cluster
  ]
}
