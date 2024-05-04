module "vpc" {
  source = "../modules/vpc"
  user_data = "../resources/user_data.sh"
}
