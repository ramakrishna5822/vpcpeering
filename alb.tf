resource "aws_lb" "application" {
    count = 1
    name = "naveen-application-loadbalncer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg.id]  
    subnets = element(aws_subnet.public.*.id,count.index)
    tags = {
        Name = "${var.vpc_name}-loadbalancer"
    }
}

resource "aws_lb_target_group" "ram" {
    name = "naveen-target"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.dev.id
    health_check {
      interval = 30
      path = "/index.html"
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
      matcher = 200
    }
    tags = {
        Name = "${var.vpc_name}-target"
    }
  
}

resource "aws_lb_listener" "http" {
load_balancer_arn = aws_lb.application.arn
port =80
protocol = "HTTP"
default_action {
  type = "application"
  target_group_arn = aws_lb_target_group.ram.arn
}
  
}