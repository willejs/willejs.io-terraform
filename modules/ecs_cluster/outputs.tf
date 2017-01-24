/* module outputs */

output "elb_dns_name" {
  value = "${aws_elb.ecs_asg_elb.dns_name}"

  // outputs dont support descriptions yet!

  // description = "Output the dns name of the load balancer for DNS records"
}

output "elb_zone_id" {
  value = "${aws_elb.ecs_asg_elb.zone_id}"

  // outputs dont support descriptions yet!

  // description = "Output the dns zone of the load balancer for DNS alias record"
}