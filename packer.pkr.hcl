packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu-node" {
  region           = var.aws_region
  instance_type    = "t2.micro"
  ami_name         = "node-app-ami-{{timestamp}}"
  ssh_username     = "ubuntu"

  source_ami_filter {
    filters = {
      name                = "Ubuntu Server 24.04 LTS (HVM), SSD Volume Type-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["624338972180"]
    most_recent = true
  }
}

build {
  name    = "build-node-app-ami"
  sources = ["source.amazon-ebs.ubuntu-node"]

  provisioner "file" {
    # Copy the entire app directory as /tmp/node-app on remote
    source      = "app"
    destination = "/tmp/node-app"
  }

  provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }
}
