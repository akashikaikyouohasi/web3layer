output "az-1a_webserver_ip" {
  value = aws_instance.sample_web_server_01.public_ip
}

output "az-1c_webserver_ip" {
  value = aws_instance.sample_web_server_02.public_ip
}

