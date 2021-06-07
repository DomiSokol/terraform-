provider "google" {
  region  = "europe-west3"
  zone    = "europe-west3-a"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-medium"
  
    boot_disk {
    initialize_params {
      image = "ubuntu-1404-lts/ubuntu-1404-trusty-v20160311"
    }
  }
  
    network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}
