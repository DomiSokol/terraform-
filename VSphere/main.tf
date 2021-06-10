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

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"


  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
  }

  disk {
    label            = "disk0"
    size             = 10
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        user = "Test"
        password = "Test"
        host_name = "terraform-test"
      }

      network_interface {
      }
    }
  }
}
