module "internal_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.area_code}-external"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 4000
      to_port     = 4000
      protocol    = "tcp"
      description = "https to ELB"
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

module "internal-elb" {
  source = "terraform-aws-modules/alb/aws"

  name = "internal"

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.level1.outputs.vpc_id
  internal        = true
  subnets         = data.terraform_remote_state.level1.outputs.private_subnet_id
  security_groups = [module.internal_sg.security_group_id]

  target_groups = [
    {
      name_prefix          = "inter"
      backend_protocol     = "HTTP"
      backend_port         = 4000
      deregistration_delay = 10

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 4000
      protocol    = "HTTP"
      action_type = "forward"
    }
  ]
}
