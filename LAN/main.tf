#main.tf

module "bastion_window_ec2"{
  source = "./bastion_window_ec2"
  public_subnet_id_01 = module.vpc.public_subnet_id_01
  vpc_id = module.vpc.vpc_id
}

module "data_linux_ec2"{
  source = "./data_linux_ec2"
  private_subnet_id_02 = module.vpc.private_subnet_id_02
  vpc_id = module.vpc.vpc_id
}

module "db_linux_ec2"{
  source = "./db_linux_ec2"
  private_subnet_id_03 = module.vpc.private_subnet_id_03
  vpc_id = module.vpc.vpc_id
}

module "pivot_linux_ec2"{
  source = "./pivot_linux_ec2"
  private_subnet_id_01 = module.vpc.private_subnet_id_01
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "./vpc"
}