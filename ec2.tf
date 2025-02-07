# ec2.tf

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "WebServer"
  }
}
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "AppServer"
  }
}

resource "aws_instance" "db_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "DBServer"
  }
}


resource "aws_db_instance" "database" {
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "mydb"
  username         = "admin"
  password         = "password"
  skip_final_snapshot = true
  
  vpc_security_group_ids = [aws_security_group.sps-igw]
  
  subnet_group_name = aws_db_subnet_group.my_subnet_group.name
}
