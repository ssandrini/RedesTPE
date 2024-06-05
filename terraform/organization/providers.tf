provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

provider "aws" {
  region                   = "us-west-2"
  alias                    = "secondary"
  shared_credentials_files = ["~/.aws/credentials"]
}