output "public_app_endpoint" {
  value       = "${aws_instance.docker.public_ip}:8000"
  description = "EC2 public IP with port 8000"
}