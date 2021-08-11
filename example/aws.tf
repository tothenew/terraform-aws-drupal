terraform {
  backend "s3" {
    bucket         = "demo-testing-drupal"
    encrypt        = true
    key            = "aws-terraform-drupal/main.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock"
  }
}
