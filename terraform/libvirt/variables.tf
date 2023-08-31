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

variable node_type {
  type        = string
  description = "type of k8s node to deploy: control_plane | worker"
  default = "worker"
}


variable discovery_token_ca_cert_hash {
  type        = string
  description = "hash for validating that the root CA public key is valid, used by worker join"
  default = ""
}

variable discovery_token {
  type        = string
  description = "discovery token, used by worker join"
  default = ""
}
