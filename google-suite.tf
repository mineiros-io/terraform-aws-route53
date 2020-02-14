# Create Google Mail MX entries
resource "aws_route53_record" "google_mail_mx" {
  count = var.create && var.create_google_mail_mx ? 1 : 0

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

# Create a range of CNAMES records for Google Suite Services
resource "aws_route53_record" "google_suite_aliases" {
  for_each = var.create ? var.google_suite_services_custom_aliases : {}

  name    = each.value
  type    = "CNAME"
  zone_id = aws_route53_zone.zone[0].zone_id
  ttl     = 3600

  records = ["ghs.googlehosted.com"]
}

# Create a SPF record to prevent email spoofing
# Notice that you need to verify the SPF record: https://support.google.com/a/answer/33786?hl=en
resource "aws_route53_record" "google_spf" {
  count = var.create && var.create_google_spf ? 1 : 0

  name    = ""
  type    = "SPF"
  zone_id = aws_route53_zone.zone[0].id
  ttl     = 3600

  records = ["v=spf1 include:_spf.google.com ~all"]
}

# Create the DKIM record to enhance security for outgoing email
# Notice that you need to verify the DKIM record: https://support.google.com/a/answer/174126?hl=en
resource "aws_route53_record" "google_dkim" {
  for_each = var.create ? var.google_mail_dkim : {}

  name    = each.key
  type    = "TXT"
  zone_id = aws_route53_zone.zone[0].id
  ttl     = 3600

  records = [each.value]
}
