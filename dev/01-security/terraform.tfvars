target_groups = {
  registration-blue = {
    name        = "edion-net-registration-tg-blue"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0ee949e595e356cc9"
    target_type = "ip"
  },
  registration-green = {
    name        = "edion-net-registration-tg-green"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0ee949e595e356cc9"
    target_type = "ip"
  },
  manage-blue = {
    name        = "edion-net-manage-tg-blue"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0ee949e595e356cc9"
    target_type = "ip"
  },
  manage-green = {
    name        = "edion-net-manage-tg-green"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0ee949e595e356cc9"
    target_type = "ip"
  }
}

vpc_id  = "vpc-0ee949e595e356cc9"
sg_name = "edion-net-app-ecs-dev-sg"
ingress_rules = {
  db_access = {
    name            = "Database access"
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = ["sg-0bfa4d4d852d89b1d", "sg-0f9d08771591aecfe", "sg-049dc0be28b35b093"]
  },
  https_access = {
    name            = "HTTPS access"
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = ["sg-0bfa4d4d852d89b1d", "sg-0f9d08771591aecfe", "sg-049dc0be28b35b093"]
  },
  http_access = {
    name            = "HTTP access"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = ["sg-0bfa4d4d852d89b1d", "sg-0f9d08771591aecfe", "sg-049dc0be28b35b093"]
  }
}

egress_rules = {
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
}