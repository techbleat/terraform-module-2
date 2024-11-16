output "node1_dns" {
    value =aws_instance.node1.public_dns
}

output "node2_dns" {
    value =aws_instance.node2.public_dns
}