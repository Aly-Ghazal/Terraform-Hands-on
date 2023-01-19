output "PublicEc2_PublicIP" {
  description = "we just print the public ip of this instance in terminal"
  value= aws_instance.Public_Ec2_From_Terraform.public_ip
}

output "PublicEc2_PrivateIP" {
  description = "we just print the private ip of this instance in terminal"
  value= aws_instance.Public_Ec2_From_Terraform.private_ip
}

output "PrivateEc2_PrivateIP" {
  description = "we just print the private ip of this instance in terminal"
  value= aws_instance.Private_Ec2_From_Terraform.private_ip
}