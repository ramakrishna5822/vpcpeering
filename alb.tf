resource "aws_lb" "application" {

    name = "naveen-application-loadbalncer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg.id]  
    subnets = [aws_subnet.public[0].id,aws_subnet.public[1].id]
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

resource "aws_lb_target_group_attachment" "instances" {
    target_group_arn = aws_lb_target_group.ram.arn
    target_id = aws_instance.server[0].id
    port = 80
  
}

resource "aws_lb_listener" "http" {
load_balancer_arn = aws_lb.application.arn
port =80
protocol = "HTTP"
default_action {
  type = "forward"
  target_group_arn = aws_lb_target_group.ram.arn
}
  
}