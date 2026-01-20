resource "aws_instance" "bastion" {
    ami                    = local.ami_id
    instance_type          = "t3.micro"
    vpc_security_group_ids = [local.bastion_sg_id]
    subnet_id = local.public_subnet_id
    
    # To increase the disk space in terraform for the instance to run without showing errors 
    # we need to mount this in the remote server, if not it does not work
    root_block_device {
      volume_size = 50
      volume_type = "gp3"   # or "gp2", depending on your preference 
    }

    tags = merge(
        local.common_tags, 
        {
            Name = "${var.project}-${var.environment}-bastion"
        }
    )
}