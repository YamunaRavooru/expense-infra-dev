# output "azs_info" {
#     value= module.vpc.azs
# }
# output aws_route_info{
#     value= module.vpc.rout_table_info
# }
output "public_subnet_ids"{
  value =module.vpc.public_subnet_ids
}