resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id  


  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      security_groups  = ingress.value.security_groups 
      description = ingress.value.name
    }
  }


  egress {
    from_port   = var.egress_rules.from_port
    to_port     = var.egress_rules.to_port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.cidr_blocks
    description = "Allow all outbound traffic"
  }
  
}
