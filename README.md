# k8s_auto_deployment

Terraform deployment of a kubernetes cluster

ansible-playbook --extra-vars "kubernetes_version=v1.28" control_plane.yaml

sudo mount -o loop /var/lib/libvirt/images/control_plane_commoninit.iso /mnt
sudo umount /mnt

## Installation

* Install the control plane first
* get the token information for the join operation
* install the X worker nodes afterward

## Getting the CNI plugins

### Weave

The 2.8.1 seems to be the latest version and is from January 2021.

* cd terraform/libvirt
* `wget https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml`

## TODO

* be able to deploy worker nodes
* provide the pod-network-cidr as a var.
