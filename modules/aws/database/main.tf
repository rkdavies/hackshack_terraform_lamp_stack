resource "aws_db_subnet_group" "main" {
  name       = "aws-lamp-db-subnet"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "main" {
  identifier     = "aws-lamp-mysql"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = var.tags
}
