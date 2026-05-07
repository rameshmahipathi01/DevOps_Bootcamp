resource "aws_instance" "ramesh_ec2_instance" {

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default_subnets.ids[0]
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = var.instance_name
  })
}
