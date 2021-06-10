variable "vm_name" {
  type        = string
  description = "VM Name"
}

data "vsphere_datacenter" "dc" {
  name = "Noris"
}

data "vsphere_datastore" "datastore" {
  name          = "DemoDS"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "k8s-play-tmpl"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "testpool"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


provider "vsphere" {

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
  
  network_interface {
  network_id   = "${data.vsphere_network.network.id}"
  }

  disk {
    label            = "disk0"
    size             = 10
  }
  cdrom {
    client_device = true
  }
  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "terraform-test"
        domain    = "test.internal"
      }
      network_interface {
        network_id = "${data.vsphere_network.private.id}"
      }
    }
  }
}
