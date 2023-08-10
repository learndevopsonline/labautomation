terraform {
  backend "local" {
    path = "/opt/mikikube.tfstate"
  }
}

data "external" "zone" {
program = ["bash", "${path.root}/route53"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "minikube"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = []
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "minikube" {
  source = "github.com/scholzj/terraform-aws-minikube"

  aws_region    = "us-east-1"
  cluster_name  = "minikube"
  aws_instance_type = "t3.medium"
  ssh_public_key = "~/.ssh/id_rsa.pub"
  aws_subnet_id = element(lookup(module.vpc, "public_subnets", null), 0)
  hosted_zone = data.external.zone.result.id
  hosted_zone_private = false

  tags = {
    Name = "minikube"
  }

  addons = [
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/storage-class.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/heapster.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/dashboard.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/external-dns.yaml"
  ]
}

output "kube_config" {
  value = "Copy Kubernetes Configuration File From MiniKube\nExecute the following command\n\n\nsudo scp centos@${module.minikube.public_ip}:/home/centos/kubeconfig /tmp/kubeconfig\nsudo chmod ugo+r /tmp/kubeconfig\n\n\n"
}

