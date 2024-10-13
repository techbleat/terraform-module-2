variable node_name {}

resource "aws_instance" "app_node" {
    ami  = "ami-0b4c7755cdf0d9219"
    instance_type = "t2.micro"

    tags = {
        Name  = var.node_name
    }
  
}