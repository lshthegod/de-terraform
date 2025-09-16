# 기본 VPC 데이터 소스
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "docker_sg" {
  name_prefix = "docker-sg"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "docker_sg_ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.docker_sg.id
}

# 위험
resource "aws_security_group_rule" "docker_sg_ingress_8000" {
  type        = "ingress"
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.docker_sg.id
}

resource "aws_security_group_rule" "docker_sg_egress_all" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.docker_sg.id
}