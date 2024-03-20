resource "aws_instance" "server01" {
  ami                    = "ami-02d7fd1c2af6eead0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg01.id]
  availability_zone      = "us-east-1a"
  subnet_id              = aws_subnet.Private_sub01.id
  user_data              = file("code.sh")
  tags = {
    Name = "WebServer01"
  }

}

resource "aws_instance" "server02" {
  ami                    = "ami-02d7fd1c2af6eead0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg01.id]
  availability_zone      = "us-east-1b"
  subnet_id              = aws_subnet.Private_sub02.id
  user_data              = file("code.sh")
  tags = {
    Name = "WebServer02"
  }

}