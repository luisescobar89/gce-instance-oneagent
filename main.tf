/*
   GCP LINUX HOST DEPLOYMENT WITH ONEAGENT
*/
terraform {
  required_version = ">= 0.12.6"
}

# Configure the Google Cloud provider
provider "google" {
  # see here how to get this file
  # https://console.cloud.google.com/apis/credentials/serviceaccountkey 
  credentials = file(var.gcloud_cred_file)
  project     = var.gcloud_project
  region      = join("-", slice(split("-", var.gcloud_zone), 0, 2))
}

# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_address" "static" {
  name = "ipv4-address-${random_id.instance_id.hex}"
}

resource "google_compute_firewall" "allow_http" {
  name    = "ubuntu-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["ubuntu-${random_id.instance_id.hex}"]
}

# A single Google Cloud Engine instance
resource "google_compute_instance" "ubuntu-vm" {
  name         = var.hostname
  machine_type = var.instance_size
  zone         = var.gcloud_zone

  boot_disk {
    initialize_params {
      image = var.gce_image_name # OS version
      size  = var.gce_disk_size  # size of the disk in GB
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external ip address
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    sshKeys = "ubuntu:${file(var.ssh_pub_key)}"
  }

  tags = ["ubuntu-${random_id.instance_id.hex}"]

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = var.gce_username
    private_key = file(var.ssh_priv_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y wget",
      "sudo apt-get install -y curl",
      "sudo apt-get install -y vim"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/install-oneagent.sh"
    destination = "/tmp/install-oneagent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-oneagent.sh",
      "sudo /bin/sh /tmp/install-oneagent.sh"
    ]
  }

#install apache after OneAgent to avoid process restart
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2"
    ]
  }

}

output "ubuntu-ip" {
  value = google_compute_instance.ubuntu-vm.network_interface[0].access_config[0].nat_ip
}
