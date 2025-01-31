# PROVIDER.TF -> in this file we have put information about
# terraform settings & aws cloud provider information , THATS IT !!!
terraform {
    required_version = "~>1.9.4"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.76.0"
        }
    }
}
 
provider aws {
    region = "ap-south-1"
   
}