data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# resource "aws_network_interface" "eni_ec2" {
#   subnet_id   = aws_subnet.PublicSubnet.id
#   private_ips = ["10.0.0.7"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }


resource "aws_instance" "Ec2_From_Terraform" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    
    subnet_id = aws_subnet.PublicSubnet.id
    # credit_specification {
    #     cpu_credits = "unlimited"
    # }
    vpc_security_group_ids = [aws_security_group.PublicEC2_sg.id]
    user_data = file("./userdata.sh")
    associate_public_ip_address = true
    tags = {
        Name = "Ec2_From_Terraform"
    }
}
