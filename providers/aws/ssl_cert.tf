// This fetches the acm certificate ARN from amazon.
// You have to manually verify these certs, therefore the creation cannot be automated.
data "aws_acm_certificate" "willejs_io" {
  domain = "www.willejs.io"
  statuses = ["ISSUED"]
}