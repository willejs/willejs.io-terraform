// create zone for willejs.io domain
resource "aws_route53_zone" "willejs_io" {
  name = "willejs.io"

  tags {
    Name = "willejs.io"
  }
}

// Create just the www.willejs.io record
resource "aws_route53_record" "www_willejs_io" {
  zone_id = "${aws_route53_zone.willejs_io.zone_id}"
  name    = "www.willejs.io"
  type    = "CNAME"
  ttl     = "30"

  records = [
    "${module.ecs_cluster_1.elb_dns_name}",
  ]
}

// Set up the root A record, obviously this has to be done via an alias.
resource "aws_route53_record" "redirect_willejs_io" {
  zone_id = "${aws_route53_zone.willejs_io.zone_id}"
  name    = "willejs.io"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.redirect_willejs_io.website_domain}"
    zone_id                = "${aws_s3_bucket.redirect_willejs_io.hosted_zone_id}"
    evaluate_target_health = false
  }
}

// Set up an empty bucket that just does a redirect
resource "aws_s3_bucket" "redirect_willejs_io" {
  bucket = "willejs.io"
  acl    = "public-read"

  website {
    redirect_all_requests_to = "www.willejs.io"
  }

  tags {
    Name        = "willejs.io"
    environment = "${var.environment}"
    project     = "${var.project_name}"
    description = "Redirect to the willejs_io ELB"
  }
}
