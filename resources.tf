data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "random_pet" "name" {}

resource "aws_vpc" "botany-vpc" {
    cidr_block              = var.vpc_CIDR_block
    enable_dns_support      = "true" #gives you an internal domain name
    enable_dns_hostnames    = "true" #gives you an internal host name
    enable_classiclink      = "false"   
    instance_tenancy        = "default"
    tags = {
        Name = "Botany VPC"
    }
}

resource "aws_subnet" "botany-vpc-subnet" {
    vpc_id                  = aws_vpc.botany-vpc.id
    cidr_block              = var.subnet_CIDR_block
    map_public_ip_on_launch = var.map_public_IP 
    availability_zone       = var.availability_zone
    tags = {
        Name = "Botany VPC Subnet"
    }
}

resource "aws_internet_gateway" "botany-igw" {
    vpc_id = aws_vpc.botany-vpc.id
}

resource "aws_route_table" "botany-public-crt" {
    vpc_id = aws_vpc.botany-vpc.id
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.botany-igw.id
    }
}

resource "aws_route_table_association" "botany-crta-public-subnet"{
    subnet_id       = aws_subnet.botany-vpc-subnet.id
    route_table_id  = aws_route_table.botany-public-crt.id
}

resource "aws_security_group" "botany-sg" {
    name        = "${random_pet.name.id}-sg"
    description = "Allow inbound SSH and HTTP"
    vpc_id      = aws_vpc.botany-vpc.id
    ingress {
        description = "inbound ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
    ingress {
        description = "inbound http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
    ingress {
        description = "inbound http"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Botany SG"
    }
}

resource "tls_private_key" "botany-sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated-key" {
  key_name   = var.key_name
  public_key = tls_private_key.botany-sshkey.public_key_openssh
}

resource "aws_instance" "botany-psql-server" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = aws_key_pair.generated-key.key_name
    subnet_id               = aws_subnet.botany-vpc-subnet.id
    vpc_security_group_ids  = [ aws_security_group.botany-sg.id ]
    tags = {
        Name = "botany-psql-server-${random_pet.name.id}"
    }

    connection {
        host = self.public_ip
        user = "ec2-user"
        private_key = tls_private_key.botany-sshkey.private_key_pem
    }
    provisioner "remote-exec" {
        inline = [
            "sudo echo 'host all all ${chomp(data.http.myip.body)}/32 trust' >> /jet/etc/postgresql/pg_hba.conf",
            "/jet/etc/postgresql/init.d/postgresql restart"
        ]
    }
}