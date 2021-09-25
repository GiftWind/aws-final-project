resource "aws_launch_template" "launch_template" {
  name_prefix = "asg-instance"
  image_id = data.aws_ssm_parameter.linux_latest_ami.value
  instance_type = "t2.micro"
#   user_data = file("user_data.sh")
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 0
  max_size = 1
  min_size = 0

  default_cooldown = 300
  health_check_grace_period = 300
  health_check_type = "EC2"

  vpc_zone_identifier = [aws_subnet.vpc_two_private_subnet.id, aws_subnet.vpc_two_private_subnet_two.id]

  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}


resource "aws_autoscaling_policy" "cpu_utilization" {
  name = "cpu_utilization_tracking"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  estimated_instance_warmup = 200
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = "60"
  }
}