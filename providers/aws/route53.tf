resource "aws_route53_zone" "willejs_io" {
  name = "willejs.io"

  tags {
    Name = "willejs.io"
  }
}

resource "aws_route53_record" "www_willejs_io" {
  zone_id = "${aws_route53_zone.willejs_io.zone_id}"
  name = "www.willejs.io"
  type = "CNAME"
  ttl = "30"
  records = [
    "${module.ecs_cluster_1.elb_dns_name}"
  ]
}