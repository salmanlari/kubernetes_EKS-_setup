resource "aws_eks_cluster" "eks_cluster" {
 name = "eks_cluster"
 role_arn = var.role

 vpc_config {
  subnet_ids = [for v in var.snet: v.snet-id]
   security_group_ids = [var.eks_sg]

 }
}

 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-workernodes"
  node_role_arn  = var.node-role
  subnet_ids   = [for v in var.snet: v.snet-id]
  instance_types = ["t3a.medium"]
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
 }

