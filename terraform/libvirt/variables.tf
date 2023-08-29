variable ansible_ssh_public_key_filename {
  type        = string
  description = "Location of ansible SSH public key file."
  default = "./private_ansible_cloud_init.pub"
}


variable project_tag {
  type        = string
  description = "tag used in front on the VMs"
  default = "lfs"
}
