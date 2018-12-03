resource "aws_elb" "gl-lb" {
  name = "gl-lb"
  #availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  subnets = ["${aws_subnet.web_subnet.*.id}"]
  security_groups = ["${aws_security_group.web-sec.*.id}"]
  instances = ["${aws_instance.win2016.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  }
