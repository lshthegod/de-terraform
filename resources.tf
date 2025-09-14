# 네트워크
resource "docker_network" "msa_net" {
  name = "msa-net"
}

# server2 이미지 (로컬 Dockerfile 빌드)
resource "docker_image" "server2" {
  name         = "server2-img:latest"
  build {
    context    = "${path.module}/server2"
    dockerfile = "Dockerfile"
  }
}

# server2 컨테이너
resource "docker_container" "server2" {
  name  = "server2"
  image = docker_image.server2.image_id

  ports {
    internal = 8000
    external = 8002
  }

  networks_advanced {
    name = docker_network.msa_net.name
  }
}

# server1 이미지 (로컬 Dockerfile 빌드)
resource "docker_image" "server1" {
  name         = "server1-img:latest"
  build {
    context    = "${path.module}/server1"
    dockerfile = "Dockerfile"
  }
}

# server1 컨테이너
resource "docker_container" "server1" {
  name  = "server1"
  image = docker_image.server1.image_id

  env = [
    "SERVER2_URL=http://server2:8000"
  ]

  ports {
    internal = 8000
    external = 8000
  }

  networks_advanced {
    name = docker_network.msa_net.name
  }

  depends_on = [docker_container.server2]
}
