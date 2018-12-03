resource "aws_iam_role" "s3fromec2_role" {
    name = "s3fromec2_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "s3fromec2_profile" {
    name = "s3fromec2_profile"
    roles = ["s3fromec2_role"]
}

resource "aws_iam_role_policy" "s3fromec2_role_policy" {
  name = "s3fromec2_role_policy"
  role = "${aws_iam_role.s3fromec2_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::gl-test-sinelnikov1"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["arn:aws:s3:::gl-test-sinelnikov1/*"]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "apps_bucket" {
    bucket = "gl-test-sinelnikov1"
    acl = "private"
    versioning {
            enabled = true
    }
}

resource "aws_s3_bucket_object" "bucket" {
    bucket = "${aws_s3_bucket.apps_bucket.id}"
    key = "index.html"
    source = "../index.html"
    etag = "${md5(file("../index.html"))}"
}
