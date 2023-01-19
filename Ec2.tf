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


resource "aws_instance" "Public_Ec2_From_Terraform" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    
    subnet_id = aws_subnet.Subnet[0].id

    vpc_security_group_ids = [aws_security_group.PublicEC2_sg.id]
    user_data = file("./userdata.sh")
    associate_public_ip_address = true
    tags = {
        Name = "Public_Ec2_From_Terraform"
    }
}


resource "aws_instance" "Private_Ec2_From_Terraform" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    
    subnet_id = aws_subnet.Subnet[1].id

    vpc_security_group_ids = [aws_security_group.PrivateEC2_sg.id]
    user_data = file("./userdata.sh")
    tags = {
        Name = "Private_Ec2_From_Terraform"
    }
}