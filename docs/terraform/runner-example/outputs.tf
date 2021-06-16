output "instance_ip" {
  value = aws_instance.windows_runner.public_ip
}
