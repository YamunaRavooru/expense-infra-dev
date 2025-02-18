module "sg_mysql"{
    source ="git::https://github.com/YamunaRavooru/sg-module.git?ref=main"
    project= var.project_name
    environment=var.environment
    sg_name ="mysql"
    common_tags=var.common_tags
    sg_description= "security group for expense project mysql instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value

}
module "sg_backend"{
    source ="git::https://github.com/YamunaRavooru/sg-module.git?ref=main"
    project= var.project_name
    environment=var.environment
    sg_name ="backend"
    common_tags=var.common_tags
    sg_description= "security group for expense project backend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value

}
module "sg_frontend"{
    source ="git::https://github.com/YamunaRavooru/sg-module.git?ref=main"
    project= var.project_name
    environment=var.environment
    sg_name ="frontend"
    common_tags=var.common_tags
    sg_description= "security group for expense project frontend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value

}
module "sg_bastion"{
    source ="git::https://github.com/YamunaRavooru/sg-module.git?ref=main"
    project= var.project_name
    environment=var.environment
    sg_name ="bastion"
    common_tags=var.common_tags
    sg_description= "security group for expense project bastion instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}
module "sg_app_alb"{
    source ="git::https://github.com/YamunaRavooru/sg-module.git?ref=main"
    project= var.project_name
    environment=var.environment
    sg_name ="app_alb"
    common_tags=var.common_tags
    sg_description= "security group for expense project backend ALB"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}
# ports 22,  443,  1194, 943 ---> vpn ports
module "sg_vpn"{
    source ="git::https://github.com/YamunaRavooru/sg-module.git?ref=main"
    project= var.project_name
    environment=var.environment
    sg_name ="vpn"
    common_tags=var.common_tags
    sg_description= "security group for expense project vpn"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}
#app alb accepting traffic from bation
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
 source_security_group_id  = module.sg_bastion.sg_id
  security_group_id = module.sg_app_alb.sg_id
}
# JDOPS-32, Bastion host should be accessed from office n/w
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
 protocol          = "tcp"
 cidr_blocks    = ["0.0.0.0/0"]
security_group_id = module.sg_bastion.sg_id
}
# vpn port 22 
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
 protocol          = "tcp"
 cidr_blocks    = ["0.0.0.0/0"]
security_group_id = module.sg_vpn.sg_id
}
#vpn port 443
resource "aws_security_group_rule" "vpn_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
 protocol          = "tcp"
 cidr_blocks    = ["0.0.0.0/0"]
security_group_id = module.sg_vpn.sg_id
}
resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
 protocol          = "tcp"
 cidr_blocks    = ["0.0.0.0/0"]
security_group_id = module.sg_vpn.sg_id
}
resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
 protocol          = "tcp"
 cidr_blocks    = ["0.0.0.0/0"]
security_group_id = module.sg_vpn.sg_id
}
#app alb access trafic from vpc
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
 source_security_group_id  = module.sg_vpn.sg_id
  security_group_id = module.sg_app_alb.sg_id
}
#mysql host should be acessed  trafic from bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
 source_security_group_id  = module.sg_bastion.sg_id
  security_group_id = module.sg_mysql.sg_id
}
resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
 source_security_group_id  = module.sg_vpn.sg_id
  security_group_id = module.sg_mysql.sg_id
}
resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 source_security_group_id  = module.sg_vpn.sg_id
  security_group_id = module.sg_backend.sg_id
}
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
 source_security_group_id  = module.sg_vpn.sg_id
  security_group_id = module.sg_backend.sg_id
}
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
 source_security_group_id  = module.sg_app_alb.sg_id
  security_group_id = module.sg_backend.sg_id
}
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
 source_security_group_id  = module.sg_backend.sg_id
  security_group_id = module.sg_mysql.sg_id
}
