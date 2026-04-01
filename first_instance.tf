provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "Terraform_Test" {
  ami           = "ami-0198cdf7458a7a932"
  instance_type = "t3.micro"

  tags = {
    Name = "Test Terraform"
  }
}
