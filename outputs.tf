output "botany-server-public-ip" {
  value = aws_instance.botany-psql-server.public_ip
}

output "botany-server-public-dns" {
  value = aws_instance.botany-psql-server.public_dns
}