module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.area_code}-private"
  description = "allow port 80 and 4000 TCP node server"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

    ingress_with_cidr_blocks = [
    {
      from_port   = 4000
      to_port     = 4000
      protocol    = "tcp"
      description = "Node server"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "https to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "backend-autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"

  name                      = var.area_code
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 400
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.terraform_remote_state.level1.outputs.private_subnet_id
  target_group_arns         = module.internal-elb.target_group_arns
  force_delete              = true

  launch_template_name        = var.area_code
  launch_template_description = "Launch template"
  update_default_version      = true
  launch_template_version     = "$Latest"

  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [module.backend_sg.security_group_id]
  user_data       = file("${path.module}/back-end.sh")

  create_iam_instance_profile = true
  iam_role_name               = var.area_code
  iam_role_path               = "/ec2/"

  iam_role_description = "IAM role for Session Manager"
  iam_role_tags = {
    CustomIamRole = "No"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
