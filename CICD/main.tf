#main.tf

module "web_ec2"{
  source = "./web_ec2"
  public_subnet_id_01 = module.vpc.public_subnet_id_01
  vpc_id = module.vpc.vpc_id
}

module "db_ec2"{
  source = "./db_ec2"
  public_subnet_id_02 = module.vpc.public_subnet_id_02
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "./vpc"
}