
module "networking" {
  source      = "../../modules/networking"
  environment = var.environment
  aws_region  = var.aws_region
  vpc_id = module.networking.vpc_id
  private_route_table_id = module.networking.private_route_table_id
}

module "security_groups" {
  source         = "../../modules/security_groups"
  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  container_port = 3000
}

module "ecr" {
  source          = "../../modules/ecr"
  environment     = var.environment
  repository_name = "app"
}

module "dynamodb" {
  source      = "../../modules/dynamodb"
  environment = var.environment
  table_name  = var.table_name
}

module "iam" {
  source             = "../../modules/iam"
  environment        = var.environment
  dynamodb_table_arn = module.dynamodb.table_arn
}

module "alb" {
  source            = "../../modules/alb"
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

module "cloudfront" {
  source       = "../../modules/cloudfront"
  environment  = var.environment
  alb_dns_name = module.alb.alb_dns_name
}

module "monitoring" {
  source           = "../../modules/monitoring"
  environment      = var.environment
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
  alb_arn_suffix   = module.alb.alb_arn_suffix
  alarm_email      = var.alarm_email
}

module "ecs_autoscaling" {
  source       = "../../modules/ecs_autoscaling"
  environment  = var.environment
  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}

module "ecs" {
  source                  = "../../modules/ecs"
  environment             = var.environment
  aws_region              = var.aws_region
  app_image               = "${module.ecr.repository_url}:latest"
  dynamodb_table_name     = module.dynamodb.table_name
  subnet_ids              = module.networking.private_subnet_ids
  security_group_id       = module.security_groups.ecs_sg_id
  target_group_arn        = module.alb.target_group_arn
  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn
  log_group_name          = module.monitoring.log_group_name
  desired_count           = 1
}
