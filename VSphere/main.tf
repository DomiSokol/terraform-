provider "vra" {
  insecure = true
  url = "https://vra8.vdi.sclabs.net"
  refresh_token = "uhlsrxhilMjgdzAwgxPXOs8Lbe6Pyw6h"
}

resource "vra_machine" "this" {
  name        = "tf-machine"
  description = "terrafrom test machine"
  project_id  = data.vra_project.this.id
  image       = "Ubuntu"
  flavor      = "Test-Flavor-Small"

  boot_config {
    content = <<EOF
#cloud-config
  users:
  - default
  - name: myuser
    plain_text_passwd: "Test"
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: '/bin/bash'
    ssh-authorized-keys: |
      ssh-rsa your-ssh-rsa:
    - sudo sed -e 's/.*PasswordAuthentication yes.*/PasswordAuthentication no/' -i /etc/ssh/sshd_config
    - sudo service sshd restart
EOF
  }

}

