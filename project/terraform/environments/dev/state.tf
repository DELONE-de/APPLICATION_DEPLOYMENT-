terraform {
  backend "s3" {
    bucket  = ""  # add your bucket name here
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
