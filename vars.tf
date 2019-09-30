variable "gcloud_project" {
  description = "Name of GCloud project to spin up the bastion host"
  default     = "detroit-acl-v2"
}

variable "gcloud_zone" {
  description = "Zone of the GCloud project"
  default     = "us-central1-a"
}

variable "gcloud_cred_file" {
  description = "Path to GCloud credential file"
}

variable "instance_size" {
  description = "Size of the bastion host"
  default     = "n1-standard-2"
}

variable "gce_image_name" {
  description = "The image to use for this vm"
  default     = "ubuntu-minimal-1804-bionic-v20190628"
}

variable "ssh_pub_key" {
  description = "Path to public SSH key"
  default     = "./key.pub"
}

variable "ssh_priv_key" {
  description = "Path to private SSH key"
  default     = "./key"
}

variable "hostname" {
  description = "Name of the gke clusters followed by count.index + 1"
  default     = "ubuntu-vm"
}

variable "gce_username" {
  description = "The user name to use for basic auth for the cluster."
  default     = "ubuntu"
}

variable "gce_disk_size" {
  description = "Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB"
  default     = 40
}