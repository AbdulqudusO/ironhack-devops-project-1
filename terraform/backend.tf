terraform {
  backend "s3" {
    bucket       = "ironhack-tfstate-686699774218-9ad64deb"
    key          = "ironhack-voting-app/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
