module "first-machine" {
    source = "../techbleat-module"
    node_name = var.node1
}
module "second-machine" {
    source = "../techbleat-module"
    node_name = var.node2
}
variable "node1" {}
variable "node2" {}




