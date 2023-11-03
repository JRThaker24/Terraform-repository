provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIARCK7OGBENLRPSTGT"
  secret_key = "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"
}

resource "aws_instance" "fst-terra-ec2" {
  ami           = var.aws_ami
  instance_type = "t2.micro"
  tags = {
    Name = "first_terraform_instance"
  }

}

resource "aws_instance" "condi-ec2-testname" {
  ami           = data.aws_ami.condi-test.id
  instance_type = "t2.micro"
  count         = var.istest == true ? 2 : 0
  tags = {
    Name = "condi-test.${count.index}"
  }
}

resource "aws_instance" "forech" {
  ami = data.aws_ami.condi-test.id
  for_each = {
    key1 = "t2.micro"
    key2 = "t2.micro"
  }
  instance_type = each.value
  tags = {
    Name = each.key
  }

}
resource "aws_ec2_instance_state" "condi-ec2-testname" {
  instance_id = aws_instance.condi-ec2-testname[0].id
  state       = var.cstate == true ? "running" : "stopped"

}



resource "aws_ec2_instance_state" "fst-terra-ec2" {
  instance_id = aws_instance.fst-terra-ec2.id
  state       = var.cstate == true ? "running" : "stopped"
}

resource "aws_ec2_instance_state" "forech" {
  for_each    = toset(["key1", "key2"])
  instance_id = aws_instance.forech[each.key].id
  state       = var.cstate == true ? "running" : "stopped"
}

resource "aws_iam_user" "terra-users" {
  name  = var.terra-iam[count.index]
  count = 3
  path  = "/system/"

  tags = {
    tag-key = "terra-users"
  }
}



output "public-ip" {
  value = aws_instance.fst-terra-ec2.public_ip
}
output "aws_instance" {
  value = aws_instance.fst-terra-ec2.ami
}

data "aws_ami" "condi-test" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
