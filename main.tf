provider "aws" {

    region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDS7Gmw1FWB14ABJJ77KVobI94te26CiC5TP7XSGkV6l1Ca1JkCe/MPjn+Fvxb2LXAwWGlZhKqyxpafpB17/nRxTzJ7egiekQzzUKGZo/hoNvQKx1ht+oG2+Dv+0bQzD//QWoM8TwG7Is56ONjYCmWGKEmyQ3cllNVFSbpI7xeqP6NTot9qra39vfkw+GPS6Y9xq6qw14ltCunSjnf17a9shYgm2xvQ7e7EOBJ5Ay8pXoFejCxdjNX6x33a+eCaYciIQr4Yv55Nguh+vSpJ3LkHyOCX8edaR3FRuvSqW+KkN8NBgZnEeZ8W9xxMNrGABjFwdFrHGiVyPQc41TE8BbVr ubuntu@ip-172-31-44-5"

}
resource "aws_instance" "k8Master"{
   ami                              = "ami-0bbe28eb2173f6167"
   instance_type                    = var.master_instance_type
   vpc_security_group_ids           =  ["sg-07bb171a2cbb779a3"]
   key_name                         = aws_key_pair.main.key_name
   associate_public_ip_address      = true
   tags                             = {
       Name                         = "master"
   }
   provisioner "local-exec" {
           command = "echo [master] '\n' ${aws_instance.k8Master.public_ip}|tee >> inventory"

        }
}

resource "aws_instance" "k8Worker"{
   ami                              = "ami-0bbe28eb2173f6167"
   instance_type                    = var.worker_instance_type
   vpc_security_group_ids           =  ["sg-07bb171a2cbb779a3"]
   key_name                         = aws_key_pair.main.key_name
   associate_public_ip_address      = true
   tags                             = {
       Name                         = "worker"
   }
   provisioner "local-exec" {
           command = "echo  [worker] '\n' ${aws_instance.k8Worker.public_ip}|tee >> inventory"
        }
}
