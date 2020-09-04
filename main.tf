provider "aws" {

    region = "us-east-2"
}

resource "aws_key_pair" "main" {
    key_name      = "publickey"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6W8MoWCGE9eXExKcpCELAON4esfJVzVT2aJFp3dviMwqPO/B1JxBmC1vLCv0NpfeOtQFMVySp6mFjMw3A9Pihca/UqT6SedKtpXiTn2wlEnW2dMCh0SeT+TielCGE3CCw+ogsYZ7iWz7xHZKntall/8tjA/mowaiLvT0KN9e6ObJpQw4fwgm/d/jjn5coy+QRvzsl6rvfyyHhPew4i7XBqzMGoCQLeUks7pqvaqZKD/unPfhgk+uVk7tFn6cmhlZ7n+mrBxDRSEZdKkTP+MBdA6H6/b+6V05i7p38RPYgxCcz85x80WpYvMMcPF5v/c3nfzg0dVlzPAelrZqHq5Xl ubuntu@ip-172-31-46-232"

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
