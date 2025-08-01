#main.tf

module "web_ec2"{
  source = "./web_ec2"
  public_subnet_id_01 = module.vpc.public_subnet_id_01
  vpc_id = module.vpc.vpc_id
  db_ec2_public_ip = module.db_ec2.db_ec2_public_ip
}

module "db_ec2"{
  source = "./db_ec2"
  public_subnet_id_02 = module.vpc.public_subnet_id_02
  vpc_id = module.vpc.vpc_id
  ec2_profile = module.web_ec2.ec2_profile
}

module "vpc" {
  source = "./vpc"
}

module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_id_01 = module.vpc.public_subnet_id_01
  public_subnet_id_02 = module.vpc.public_subnet_id_02
  web_ec2_instance_id = module.web_ec2.web_ec2_instance_id
}

module "codebuild" {
  source = "./"codebuild""
  db_ec2_public_ip  = module.codebuild.db_ec2_public_ip
}

module "codepipeline" {
  source = "./"codepipeline""
  codebuild_name  = module.codebuild.codebuild_name
  codedeploy_id = module.codedeploy.codedeploy_id
}

module "codedeploy" {
  source = "./"codedeploy""
  alb_target_group_name  = module.alb.alb_target_group_name
}


