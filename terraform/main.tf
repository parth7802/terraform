provider "aws" {
  region = "ap-south-1"
}

module "iam" {
  source = "./modules/iam"
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
  log_group_name      = "/ecs/nginx-task"
  log_group_retention = 7

  container_name      = "nginx-container"
  container_image     = "nginx:latest"
  container_cpu       = 128
  container_memory    = 256
  task_cpu            = "256"
  task_memory         = "512"

  execution_role_arn  = module.iam.ecs_task_execution_role_arn
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.ecs_service_sg_id]
  target_group_arn    = module.alb_nginx.target_group_arn
  listener_dependency = module.alb_nginx.listener
  region              = "ap-south-1"
}
module "ecs_apache" {
  source = "./modules/ecs"

  cluster_name        = "ecs-cluster"
  log_group_name      = "/ecs/apache-task"
  log_group_retention = 7

  container_name      = "apache-container"
  container_image     = "httpd:latest"
  container_cpu       = 128
  container_memory    = 256
  task_cpu            = "256"
  task_memory         = "512"

  execution_role_arn  = module.iam.ecs_task_execution_role_arn
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.ecs_service_sg_id]
  target_group_arn    = module.alb_apache.target_group_arn
  listener_dependency = module.alb_apache.listener
  region              = "ap-south-1"
}

module "ecs_tomcat" {
  source = "./modules/ecs"

  cluster_name        = "ecs-cluster"
  log_group_name      = "/ecs/tomcat-task"
  log_group_retention = 7

  container_name      = "tomcat-container"
  container_image     = "tomcat:9"
  container_cpu       = 256
  container_memory    = 512
  task_cpu            = "512"
  task_memory         = "1024"

  container_port = 8080

  execution_role_arn  = module.iam.ecs_task_execution_role_arn
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.ecs_service_sg_id]
  target_group_arn    = module.alb_tomcat.target_group_arn
  listener_dependency = module.alb_tomcat.listener
  region              = "ap-south-1"
}

module "alb_nginx" {
  source                 = "./modules/alb"
  alb_name               = "nginx-alb"
  is_internal            = false
  alb_security_group_ids = [module.vpc.alb_sg_id]
  subnet_ids             = module.vpc.public_subnet_ids
  target_group_name      = "nginx-tg"
  target_group_port      = 80
  listener_port          = 80
  vpc_id                 = module.vpc.vpc_id
}

module "alb_apache" {
  source                 = "./modules/alb"
  alb_name               = "apache-alb"
  is_internal            = false
  alb_security_group_ids = [module.vpc.alb_sg_id]
  subnet_ids             = module.vpc.public_subnet_ids
  target_group_name      = "apache-tg"
  target_group_port      = 80
  listener_port          = 80
  vpc_id                 = module.vpc.vpc_id
}

module "alb_tomcat" {
  source                 = "./modules/alb"
  alb_name               = "tomcat-alb"
  is_internal            = false
  alb_security_group_ids = [module.vpc.alb_sg_id]
  subnet_ids             = module.vpc.public_subnet_ids
  target_group_name      = "tomcat-tg"
  target_group_port      = 8080
  listener_port          = 80
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
