provider "docker" {}

resource "docker_volume" "jenkins_home" {}

resource "docker_network" "jenkins_net" {
  name = "jenkins_net"
}

# Docker image
resource "docker_image" "jenkins" {
  name = "jenkins/jenkins:lts"
}

# Create a container
resource "docker_container" "jenkins" {
  name  = "jenkins"
  #image = "jenkins/jenkins:lts"
  image = docker_image.jenkins.name
  restart = "always"
  network_mode = "jenkins_net"
  env = [
    "JAVA_OPTS=-Dhudson.footerURL=http://acme.com"
  ]
  ports {
    internal = "8080"
    external = var.jenkins_port
    ip = "127.0.0.1"
  }
  ports {
    internal = "50000"
    external = var.jenkins_attach_port
    ip = "127.0.0.1"
  }
  mounts {
    type = "volume"
    target = "/var/jenkins_home"
    source = "jenkins_home"
  }
}
