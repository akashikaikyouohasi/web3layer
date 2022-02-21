# ターゲットグループ設定
resource "aws_lb_target_group" "sample_elb_target" {
    # target type
    target_type = "instance"
    # name   
    name = "sample-elb-target"
    # protocol
    protocol = "HTTP"
    # port
    port = "80"
    # VPC
    vpc_id = var.vpc_id
    # protocol version
    protocol_version = "HTTP1"
    
    # Health check
    health_check {
        enabled = true
        # protocol
        protocol = "HTTP"
        # path
        path = "/"
        # port
        port = "traffic-port"
        # threshold
        healthy_threshold = 5
        unhealthy_threshold = 2
        timeout = 5
        interval = 30
        # Success codes
        matcher = 200
        
    }
}

resource "aws_lb_target_group_attachment" "attach_instance_1" {
    target_group_arn = aws_lb_target_group.sample_elb_target.arn
    target_id = aws_instance.sample_web_server_01.id
}
resource "aws_lb_target_group_attachment" "attach_instance_2" {
    target_group_arn = aws_lb_target_group.sample_elb_target.arn
    target_id = aws_instance.sample_web_server_02.id
}


# ALB設定
resource "aws_lb" "sample_elb"{
    # ELBの種類
    load_balancer_type = "application"
    
    # name
    name = "sample-elb"
    # Scheme: インターネット向け
    internal = false
    # IP address type: ipv6は使用しない
    ip_address_type = "ipv4"
    # VPC Subnet
    subnets = [var.public_subnet_ids.ap-northeast-1a, var.public_subnet_ids.ap-northeast-1c]
    
    # Security group
    security_groups = [var.security_group_web]
    
    
}

resource "aws_lb_listener" "listener_and_routing" {
    load_balancer_arn = aws_lb.sample_elb.arn
    port = 80
    protocol = "HTTP"
    
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.sample_elb_target.arn
    }
}