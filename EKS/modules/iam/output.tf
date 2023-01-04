output "role-arn" {
    value = aws_iam_role.eks-iam-role.arn
  
}

output "workernode-role-arn" {

value = aws_iam_role.workernodes.arn
  
}