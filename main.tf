resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
}
resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
}    
#Internet gateway
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.myvpc.id
  
}
#Route table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.myvpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}
#route_table_association
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.my-rt.id
  
}
resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.my-rt.id
  
}
resource "aws_security_group" "my-sg" {
    tags = {
        name = "web-sg"
    }
  vpc_id = aws_vpc.myvpc.id
  
  #Inbound rule for HTTP
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#Outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#Creation of S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-user-s3bucket"

  tags = {
    Name        = "MyS3bucket"

  }
}
#Creation of EC2
resource "aws_instance" "server1" {
  ami           = "ami-07a00cf47dbbc844c"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id = aws_subnet.subnet1.id
  user_data = base64encode(file("userdata.sh"))

  tags = {
    Name = "WebServer1"
  }
}
resource "aws_instance" "server2" {
  ami           = "ami-07a00cf47dbbc844c"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id = aws_subnet.subnet2.id
  user_data = base64encode(file("userdata2.sh"))

  tags = {
    Name = "WebServer2"
  }
}
#create ALB
resource "aws_alb" "myalb" {
    name = "myalb"
    internal = false
    load_balancer_type = "application"

    security_groups = [aws_security_group.my-sg.id]
    subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

    tags = {
        Name = "web"

    } 
}

resource "aws_alb_target_group" "tg" {
    name     = "myTG"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.myvpc.id

    health_check {
    path = "/"
    port = "traffic-port"
  }
}
resource "aws_alb_target_group_attachment" "attach1" {
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "attach2" {
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_alb.myalb.dns_name
}


