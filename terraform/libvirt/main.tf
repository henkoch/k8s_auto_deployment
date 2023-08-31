# Configure the Libvirt provider

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest

# See: https://registry.terraform.io/providers/multani/libvirt/latest/docs

provider "libvirt" {
  uri = "qemu:///system"
}



# ------------------------------------ CONTROL-PLANE

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.12/ubuntu/ubuntu-example.tf
# https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/
data "template_file" "control_plane_user_data" {
  template = file("./cloud-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key = file(var.ansible_ssh_public_key_filename)
    node_type = "control_plane"
    vm_hostname = "cp"
    cni_weave_installation_file_base64 = filebase64("weave-daemonset-k8s.yaml")
    cni_calico_custom_resources_file_base64 = filebase64("calico-custom-resources.yaml")
    ansible_playbook_file_base64 = filebase64("../../ansible_playbook/k8s_node_ansible_playbook.yaml")
    discovery_token_ca_cert_hash = var.discovery_token_ca_cert_hash
    discovery_token = var.discovery_token
  }
}

resource "libvirt_cloudinit_disk" "control_plane_commoninit" {
  name      = "control_plane_commoninit.iso"
  user_data = data.template_file.control_plane_user_data.rendered
}

# Defining VM Volume
resource "libvirt_volume" "control_plane_node_os-qcow2" {
  name = "${var.project_tag}_control_plane.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "control_plane_node-vm" {
  name   = "${var.project_tag}_control_plane_vm"
  memory = "8192"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.control_plane_commoninit.id

  network_interface {
    network_name = "default" # List networks with virsh net-list
    bridge = "virbr0"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.control_plane_node_os-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

# ------------------------------------ WORKER

data "template_file" "worker_user_data" {
  template = file("./cloud-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key = file(var.ansible_ssh_public_key_filename)
    node_type = "worker"
    vm_hostname = "worker"
    cni_weave_installation_file_base64 = filebase64("weave-daemonset-k8s.yaml")
    cni_calico_custom_resources_file_base64 = filebase64("calico-custom-resources.yaml")
    ansible_playbook_file_base64 = filebase64("../../ansible_playbook/k8s_node_ansible_playbook.yaml")
    discovery_token_ca_cert_hash = var.discovery_token_ca_cert_hash
    discovery_token = var.discovery_token
  }
}

resource "libvirt_cloudinit_disk" "worker_commoninit" {
  name      = "worker_commoninit.iso"
  user_data = data.template_file.worker_user_data.rendered
}


# Defining VM Volume
resource "libvirt_volume" "worker_node_os-qcow2" {
  name = "${var.project_tag}_worker.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}


# Define KVM domain to create
resource "libvirt_domain" "worker_node-vm" {
  name   = "${var.project_tag}_worker_vm"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.worker_commoninit.id

  network_interface {
    network_name = "default" # List networks with virsh net-list
    bridge = "virbr0"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.worker_node_os-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}


# Output Server IP
#output "ip" {
#  value = "${libvirt_domain.control_plane_node-vm.network_interface.0.addresses.0}"
#}

#output "worker_ip" {
#  value = "${libvirt_domain.worker_node-vm.network_interface.0.addresses.0}"
#}