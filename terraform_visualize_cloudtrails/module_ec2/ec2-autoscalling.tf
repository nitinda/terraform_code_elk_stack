resource "aws_autoscaling_group" "demo-autoscaling-group-ec2" {
  # availability_zones        = ["${data.aws_availability_zones.demo-available.names}"]
  name_prefix               = "terraform-demo-autoscaling-group-ec2"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 0
  force_delete              = false
  vpc_zone_identifier       = ["${var.vpc_zone_identifier}"]
  default_cooldown          = 1
  target_group_arns = ["${aws_lb_target_group.demo-application-loadbalancer-target-group.arn}"]
  
  tag {
    key                 = "Name"
    value               = "terraform-demo-ec2"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${lookup(var.common_tags, "Owner")}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${lookup(var.common_tags, "Project")}"
    propagate_at_launch = true
  }

  tag {
    key                 = "BusinessUnit"
    value               = "${lookup(var.common_tags, "BusinessUnit")}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${lookup(var.common_tags, "Environment")}"
    propagate_at_launch = true
  }
  
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.demo-launch-template-ec2.id}"
        version = "$$Latest"
      }

      override {
        instance_type = "t3a.micro"
      }

      override {
        instance_type = "t3a.small"
      }
    }
    instances_distribution {
      on_demand_allocation_strategy = "prioritized"
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy = "lowest-price"
      spot_instance_pools = 2
    }
  }
}