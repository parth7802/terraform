provider "aws" {
  region = "ap-south-1"
}
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr               = "10.0.0.0/16"
  vpc_name               = "ecs-vpc"
  public_subnet_1_cidr   = "10.0.1.0/24"
  public_subnet_2_cidr   = "10.0.2.0/24"
  private_subnet_1_cidr  = "10.0.3.0/24"
  private_subnet_2_cidr  = "10.0.4.0/24"
  az_1                   = "ap-south-1a"
  az_2                   = "ap-south-1b"
}
module "ecs" {
  source = "./modules/ecs"

  cluster_name        = "ecs-cluster"
  log_group_name      = "/ecs/web-task"
  log_group_retention = 7

  container_name      = "nginx-container"
  container_image     = "nginx:latest"
  container_cpu       = 128
  container_memory    = 256
  task_cpu            = "256"
  task_memory         = "512"

  execution_role_arn  = data.aws_iam_role.ecs_task_execution_role.arn
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.ecs_service_sg_id]
  target_group_arn    = module.alb.target_group_arn
  listener_dependency = module.alb.listener
  region              = "ap-south-1"
}
module "alb" {
  source                 = "./modules/alb"
  alb_name               = "ecs-alb"
  is_internal            = false
  alb_security_group_ids = [module.vpc.alb_sg_id] # Or your hardcoded SG ID
  subnet_ids             = module.vpc.public_subnet_ids
  target_group_name      = "ecs-tg"
  vpc_id                 = module.vpc.vpc_id
}
module "nat" {
  source              = "./modules/nat"
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  private_subnet_ids = {
    subnet1 = module.vpc.private_subnet_ids[0]
    subnet2 = module.vpc.private_subnet_ids[1]
  }
  vpc_id              = module.vpc.vpc_id
  igw_dependency      = module.vpc.igw # Output this from your VPC module
}
