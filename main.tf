provider "aws" {
  region     = "ap-northeast-2"
}

# 기본 서브넷 데이터 소스
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_instance" "docker" {
  ami           = "ami-00e73adb2e2c80366" # Ubuntu 24.04 LTS
  instance_type = "t2.micro"
  key_name = aws_key_pair.docker_make_keypair.key_name
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  subnet_id = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  user_data = <<-EOF
            #!/bin/bash
            # 패키지 업데이트
            apt update -y

            # Docker 설치
            apt install -y docker.io

            # Docker 데몬 실행 및 부팅 시 자동 실행
            systemctl start docker
            systemctl enable docker

            # 현재 유저(ubuntu)를 docker 그룹에 추가
            usermod -aG docker ubuntu

            # Docker Compose 설치
            sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

            # 실행 권한 부여
            sudo chmod +x /usr/local/bin/docker-compose

            # docker compose 명령어를 위해 심볼릭 링크 생성 (선택 사항이지만 권장)
            sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

            # GitHub Repo 클론
            # ubuntu 사용자로 실행되도록 디렉토리 변경 및 권한 설정
            cd /home/ubuntu
            git clone https://github.com/lshthegod/de-terraform.git
            chown -R ubuntu:ubuntu /home/ubuntu/de-terraform
            cd de-terraform

            # Docker Compose 실행
            # ubuntu 사용자로 docker-compose 실행
            sudo -u ubuntu /usr/local/bin/docker-compose up --build -d

            EOF

  tags = {
    Name = "docker"
  }
}