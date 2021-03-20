variable "access_key" {}
variable "secret_key" {}
provider "aws" {    
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-west-2"
}
resource "aws_security_group" "demo-sg" {
        name                = "demo-sg"
        description         = "Allow ssr and ssh from the internet"
        ingress {
                from_port       = 22
                to_port         = 22
                protocol        = "tcp"
                cidr_blocks     = ["0.0.0.0/0"]
                description     = "Plain HTTP"
        }
        ingress {
                from_port       = 2048
                to_port         = 2048
                protocol        = "tcp"
                cidr_blocks     = ["0.0.0.0/0"]
                description     = "Plain HTTP"
        }
        tags = {
                Name = "ssr ssh"
        }
        user_data = "wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh\nchmod +x shadowsocksR.sh << EOF \n${var.password}\n${var.port}\n{var.sec}\n${var.http}\n${var.obfs}\n"
}
resource "aws_instance" "ubuntuinstance" {
  ami           = "ami-0ca5c3bd5a268e7db"
  instance_type = "t2.micro" 
  key_name = "csye7220" 
  tags = {
        Name = "csye7220"
        OS = "ubuntu"
  }
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
}
output "public_ip_ubuntu" {
  value = [
    aws_instance.ubuntuinstance.public_ip
  ]
}