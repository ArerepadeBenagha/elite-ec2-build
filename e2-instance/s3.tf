resource "aws_s3_bucket" "terraform-state-" {
  bucket = "terraform-state-745dgc"
  acl    = "private"
  versioning {
    enabled = true
  }
}
resource "aws_s3_bucket" "elite-dev" {
  bucket = "my-bucket-infra"
  acl    = "public-read"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "elite-infra-bucket-Dev"
    Environment = "Dev"
  }
}
# resource "aws_s3_bucket" "elite-dev" {
#   bucket = "elite-dev"
# }

resource "aws_s3_bucket_policy" "elite-dev" {
  bucket = aws_s3_bucket.elite-dev.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.elite-dev.arn,
          "${aws_s3_bucket.elite-dev.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}