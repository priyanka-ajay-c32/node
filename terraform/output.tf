output "public_ip" {
  value = "${chomp(data.http.icanhazip.body)}"
}

output "bastion_ip" {
    value = module.bastion_instance.public_ip
}

output "jenkins_ip" {
    value = module.jenkins_instance.private_ip
}

output "app_ip" {
    value = module.app_instance.private_ip
}