target_groups = {
  registration-blue = {
    name        = "edion-net-app-re-dev-tg-blue"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0d6e7b64616fc440d"
    target_type = "ip"
  },
  registration-green = {
    name        = "edion-net-app-re-dev-tg-green"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0d6e7b64616fc440d"
    target_type = "ip"
  },
  manage-blue = {
    name        = "edion-net-app-ma-dev-tg-blue"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0d6e7b64616fc440d"
    target_type = "ip"
  },
  manage-green = {
    name        = "edion-net-app-ma-dev-tg-green"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "vpc-0d6e7b64616fc440d"
    target_type = "ip"
  }
}

listener = {
  manage = {
    elb_arn  = "arn:aws:elasticloadbalancing:ap-northeast-1:968040114700:loadbalancer/app/testedion/8ac31d111ad814aa"
    protocol = "HTTP"
    port     = 81
    default_action = {
      type                  = "forward"
      default_target_groups = ["manage-blue"]
    }
  },
  registration = {
    elb_arn  = "arn:aws:elasticloadbalancing:ap-northeast-1:968040114700:loadbalancer/app/testedion/8ac31d111ad814aa"
    protocol = "HTTP"
    port     = 82
    default_action = {
      type                  = "forward"
      default_target_groups = ["registration-blue"]
    }
  }
}



listener_rules = {
  registration = {
    listener_key = "registration"
    priority     = 30
    condition = {
      host_header = ["registration.domain"]
    }
    forward_targets = [
      {
        target_group_key = "registration-green"
        weight           = 0
      },
      {
        target_group_key = "registration-blue"
        weight           = 100
      }
    ]
  },

  manage = {
    listener_key = "manage"
    priority     = 30
    condition = {
      host_header = ["manage.domain"]
    }
    forward_targets = [
      {
        target_group_key = "manage-green"
        weight           = 0
      },
      {
        target_group_key = "manage-blue"
        weight           = 100
      }
    ]
  }
}

vpc_id  = "vpc-0d6e7b64616fc440d"
sg_name = "edion-net-app-ecs-dev-sg"
ingress_rules = {
  db_access = {
    name            = "Database access"
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = ["sg-0cd62144c7055a2b3"]
  },
  https_access = {
    name            = "HTTPS access"
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = ["sg-0cd62144c7055a2b3"]
  },
  http_access = {
    name            = "HTTP access"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = ["sg-0cd62144c7055a2b3"]
  }
}

egress_rules = {
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
}