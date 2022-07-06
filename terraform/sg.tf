data "http" "icanhazip" {
   url = "http://icanhazip.com"
}


module "bastion_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "bastion-sg"
  description = "Security group for bastion machine"
  vpc_id      = module.vpc.vpc_id
  egress_rules             = ["all-all"]
  egress_cidr_blocks       = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "${chomp(data.http.icanhazip.body)}/32"
    }
  ]
  tags = {
    Terraform = "true"
    Environment = "upgrad-proj"
  }
}

module "private_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "private-sg"
  description = "Security group for private machine"
  vpc_id      = module.vpc.vpc_id
  egress_rules             = ["all-all"]
  egress_cidr_blocks       = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
  tags = {
    Terraform = "true"
    Environment = "upgrad-proj"
  }
}

module "web_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "web-sg"
  description = "Security group for web machine"
  vpc_id      = module.vpc.vpc_id
  egress_rules             = ["all-all"]
  egress_cidr_blocks       = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "${chomp(data.http.icanhazip.body)}/32"
    }
  ]
  tags = {
    Terraform = "true"
    Environment = "upgrad-proj"
  }
}