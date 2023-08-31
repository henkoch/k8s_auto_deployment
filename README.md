# k8s_auto_deployment

Terraform deployment of a kubernetes cluster

ansible-playbook --extra-vars "kubernetes_version=v1.28" control_plane.yaml

sudo mount -o loop /var/lib/libvirt/images/control_plane_commoninit.iso /mnt
sudo umount /mnt

## Installation

* terraform apply to deploy both the control-plan and the worker node
* get the token information for the join operation, from the control plan
* run it in the worker node.

## Getting the CNI plugins

### Weave

The 2.8.1 seems to be the latest version and is from January 2021.

* cd terraform/libvirt
* `wget https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml`

* kubeadm token create --print-join-command

kubeadm join 192.168.122.168:6443 --token agcoep.xxxxxx \
        --discovery-token-ca-cert-hash sha256:evenmorexxxx 

* --token : discovery-token
- --discovery-token-ca-cert-hash : validate that the root CA public key matches this hash

## TODO

* be able to deploy worker nodes
* provide the pod-network-cidr as a var.
