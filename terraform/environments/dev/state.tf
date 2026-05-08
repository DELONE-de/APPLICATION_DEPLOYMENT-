terraform {
  backend "s3" {
    bucket  = "my2007-terraform-state-bucket" 
    key     = "application/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
