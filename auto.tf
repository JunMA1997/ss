
provider "aws" {    
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
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
        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                Name = "ssr ssh"
        }
        
        
}
resource "aws_instance" "ubuntuinstance" {
  ami           = "ami-0ca5c3bd5a268e7db"
  instance_type = "t2.micro" 
  key_name = var.keyname
  tags = {
        Name = "csye7220"
        OS = "ubuntu"
  }
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  user_data = "#!/bin/bash\nsudo echo \"begin\">>/home/ubuntu/begin.txt \ncd /home/ubuntu\nsudo wget --no-check-certificate https://raw.githubusercontent.com/JunMA1997/ss/master/shadowsocksR.sh\nchmod +x shadowsocksR.sh\nsudo ./shadowsocksR.sh<< EOF \n${var.password}\n${var.port}\n${var.sec}\n${var.http}\n${var.obfs}\nEOF\nsudo echo \"end\">>/home/ubuntu/end.txt"
}
output "public_ip_ubuntu" {
  value = [
    aws_instance.ubuntuinstance.public_ip
  ]
}