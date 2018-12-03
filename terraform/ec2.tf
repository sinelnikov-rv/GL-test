resource "aws_instance" "win2016" {
  count="${var.number_of_instances}"
  ami = "${var.ami}"
  instance_type = "t2.micro"
  tags {
    Name="${format("test-%d",count.index+1)}"
  }
  vpc_security_group_ids = ["${aws_security_group.web-sec.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.s3fromec2_profile.id}"
}
