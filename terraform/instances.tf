data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/noble/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_key_pair" "project" {
  key_name   = "${var.project_name}-key"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name    = "${var.project_name}-key"
    Project = var.project_name
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name    = "${var.project_name}-app"
    Project = var.project_name
    Role    = "Vote-Result-Bastion"
  }
}

resource "aws_instance" "backend" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.backend.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name    = "${var.project_name}-backend"
    Project = var.project_name
    Role    = "Redis-Worker"
  }
}

resource "aws_instance" "db" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.db.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
    Role    = "PostgreSQL"
  }
}
