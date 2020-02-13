# Create Google Mail MX entries
resource "aws_route53_record" "google_mail_mx" {
  count = var.create && var.enable_google_mail_mx ? 1 : 0

  name    = ""
  type    = "MX"
  zone_id = aws_route53_zone.zone[0].id
  ttl     = var.google_mail_mx_ttl

  records = [
    "5 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM"
  ]
}
