# OneAgent Deployment with Terraform

GCP Ubuntu Apache Web Server with OneAgent installed

---

After cloning this repository, initialize the terraform working directory:

```
terraform init
```

Create key pair for ssh conection.

```
ssh-keygen -b 2048 -t rsa -f key
```

Create a .tfvars file for provisioning:

provision_ubuntu-vm.tfvars

```
gcloud_project    = "[PROJECT]]"
gcloud_zone       = "[ZONE]"
gcloud_cred_file  = "[CRED_FILE_FULL_PATH]"
instance_size     = "n1-standard-2"
gce_image_name    = "ubuntu-minimal-1804-bionic-v20190628"
gce_username      = "ubuntu"
hostname          = "[HOSTNAME]"
ssh_priv_key       = "[PRIVATE_KEY_FULL_PATH]"
```

On the Dynatrace tenant, under manage, go to Deploy Dynatrace, Start Installation, Linux and after confirming all the settings, copy and paste all 3 commands on the [install-oneagent.sh] script. For space saving purposes, the download directory can be set to /tmp/.

The file should look similar to this:

```
#!/bin/sh

wget -O /tmp/Dynatrace-OneAgent-Linux-1.177.167.sh "https://[DYNATRACE_TENANT]/api/v1/deployment/installer/agent/unix/default/latest?Api-Token=[API_TOKEN]&arch=x86&flavor=default"
wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-OneAgent-Linux-1.177.167.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null
/bin/sh /tmp/Dynatrace-OneAgent-Linux-1.177.167.sh APP_LOG_CONTENT_ACCESS=1 INFRA_ONLY=0
```

Now everything is ready for deploying the web server on GCE, execute the commands below to both validate and apply the terraform configurations to your GCP Project:

```
terraform validate -var-file=./provision_ubuntu-vm.tfvars
terraform apply -var-file=./provision_ubuntu-vm.tfvars
```

To clean up and destroy all resources created, run the following command:

```
terraform destroy -var-file=./provision_ubuntu-vm.tfvars
```

[install-oneagent.sh]:[install-oneagent.sh]
