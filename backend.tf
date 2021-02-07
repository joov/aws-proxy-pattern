
terraform {
  backend "s3" {
    bucket = "tfstate-jitsi"
    key    = "proxy"
    region = "eu-central-1"
  }
}
