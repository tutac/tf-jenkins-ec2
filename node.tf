resource "aws_security_group" "k8s_sg_ssh" {
  name        = "Allow SSH"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "k8s_node" {
  ami                         = "ami-09d3b3274b6c5d4aa"
  instance_type               = "t2.medium"
  key_name                    = "k8s_key"
  subnet_id                   = aws_subnet.custom_subnet_public_a.id
  availability_zone           = var.az-a
  vpc_security_group_ids      = [aws_security_group.k8s_sg_ssh.id]
  # user_data                   = "${file("user_data.sh")}"
  user_data_replace_on_change = true
  tags = {
    Name = "Kubernetes Single Node Cluster"
  }
}

# an empty resource block
resource "null_resource" "name" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.k8s_node.public_ip
  }

  # copy the install_jenkins.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/jenkins.sh",
      "sh /tmp/jenkins.sh"

    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.k8s_node]
}


# print the url of the jenkins server
# output "website_url" {
#   value     = join ("", ["http://", aws_instance.k8s_node.public_dns, ":", "8080"])
# }

resource "aws_key_pair" "deployer" {
  key_name   = "k8s_key"
  public_key = file("~/.ssh/k8s-key.pem")
}

output "k8s_node_public_ip" {
  value = aws_instance.k8s_node.public_ip
}

