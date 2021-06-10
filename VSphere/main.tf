variable "vm_name" {
  type        = string
  description = "VM Name"
}


provider "vsphere" {

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Noris"
}

data "vsphere_datastore" "datastore" {
  name          = "DemoDS"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "testpool"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name

  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"



  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  clone{
    template_uuid = "503cdb36-522c-0087-7117-9ae2fcf4eacb"
  }

  wait_for_guest_net_timeout    = -1
}
