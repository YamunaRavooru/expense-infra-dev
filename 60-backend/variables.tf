variable "project_name" {
  type        = string
  default     = "expense"
}
variable "environment"{
    default="dev"

}
variable "common_tags"{
    default={
        project_name ="expense"
        environment="dev"
        terraform= true
    }
}
variable "domain_name"{
    default ="daws82s.cloud"
}