module "vpc" {
    source =  "git::https://github.com/YamunaRavooru/terraform-vpc-module.git?ref=main"
    cidr_block = var.cidr_block
    project_name = var.project_name
    environment =var.environment
    common_tags =var.common_tags
    vpc_tags=var.vpc_tags
    public_subnet_cidr=var.public_subnet_cidr
    private_subnet_cidr=var.private_subnet_cidr
    database_subnet_cidr=var.database_subnet_cidr
    is_peering_required=true
} 
#this can be included in module
resource "aws_db_subnet_group" "expense" {
  name       = "${var.project_name}-${var.environment}"
  subnet_ids = module.vpc.database_subnet_ids

  tags = merge(var.common_tags,
  {
    Name = "${var.project_name}-${var.environment}"
  })
}