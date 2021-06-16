# Create an IAM role for the Web Servers.
resource "aws_iam_role" "windows_gitlab_runner" {
    name = "windows_gitlab_runner"
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

resource "aws_iam_instance_profile" "windows_gitlab_runner" {
    name = "windows_gitlab_runner"
    role = "windows_gitlab_runner"
}

resource "aws_iam_role_policy" "windows_gitlab_runner" {
  name = "windows_gitlab_runner_policy"
  role = aws_iam_role.windows_gitlab_runner.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.windows_gitlab_runner.bucket}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.windows_gitlab_runner.bucket}/*"]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "windows_gitlab_runner" {
    bucket = "windows-gitlab-runner-cache-bucket-name"
    acl = "private"

    versioning  {
      enabled = true
    }

    lifecycle_rule {
      id      = "cache"
      enabled = true

      prefix = "cache/"

      tags = {
        rule      = "cache"
        autoclean = "true"
      }

      expiration {
        days = 30
      }
    }

    tags = {
        Name = "windows_gitlab_runner"
    }

}


