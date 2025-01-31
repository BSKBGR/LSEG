# output "ec2_instance_AZ_info" {
#     value = aws_instance.tf-ec2.tags
# }
 
output "sps_vpc_id" {
    value = aws_vpc.sps-vpc.id
}
 
output "ec2_instance_type" {
    value = aws_instance.tf-ec2.instance_type
}
 
output "ec2_instance_tag_name" {
    value = aws_instance.tf-ec2.tags
}
 
output "ec2_instance_subnet_info" {
    value = aws_instance.tf-ec2.subnet_id
}