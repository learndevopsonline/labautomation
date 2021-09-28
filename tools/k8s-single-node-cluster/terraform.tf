module "minikube" {
  source              = "github.com/scholzj/terraform-aws-minikube"

  aws_region          = "us-east-1"
  cluster_name        = "minikube"
  aws_instance_type   = "t2.medium"
  ssh_public_key      = "~/.ssh/id_rsa.pub"
  aws_subnet_id       = module.vpc.public_subnets[0]
  //ami_image_id        = data.aws_ami.ami.id
  hosted_zone         = var.HOSTED_ZONE
  hosted_zone_private = true

  tags = {
    Application = "Minikube"
  }

  addons = [
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/storage-class.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/heapster.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/dashboard.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/external-dns.yaml"
  ]
}

variable "HOSTED_ZONE" {}

provider "aws" {
  region                = "us-east-1"
}

module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"

  name                  = "k8s-vpc"
  cidr                  = "10.0.0.0/16"

  azs                   = ["us-east-1a"]
  public_subnets        = ["10.0.101.0/24"]

  enable_nat_gateway    = false
  enable_vpn_gateway    = false

  tags = {
    Terraform           = "true"
    Name                = "k8s-vpc"
  }
}

output "MINIKUBE_SERVER" {
  value = "ssh centos@${module.minikube.public_ip}"
}

output "KUBE_CONFIG" {
  value = "scp centos@${module.minikube.public_ip}:/home/centos/kubeconfig ~/.kube/config"
}