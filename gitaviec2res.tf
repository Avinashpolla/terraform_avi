resource "aws_security_group" "sg" {

name = "allow_tls123"

description = "Allow TLS inbound traffic"





ingress {

description = "SSH"

from_port = 22


to_port = 22

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]



}



ingress {

description = "HTTP"

       from_port   = 8080                                                                                                                                                   1,1           Top

       to_port     = 8080

       protocol    = "tcp"

       cidr_blocks = ["0.0.0.0/0"]

}



egress {

from_port = 22

to_port = 22

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]

}



tags = {

Name = "allow_tls123"

}

}





resource "aws_instance" "aviinstance"{

ami = "ami-0022f774911c1d690"

instance_type = "t2.micro"

key_name = "mykey1"
user_data = <<-EOF
	#!/bin/bash
	yum install java-1.8.0-openjdk-devel -y

	yum install -y python3

        sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

	yum install jenkins -y

	systemctl start jenkins
EOF

tags = {
         Name = "terraform project"
       }
}



resource "aws_network_interface_sg_attachment" "sg_attachment" {

security_group_id = aws_security_group.sg.id

network_interface_id = aws_instance.aviinstance.primary_network_interface_id

}
