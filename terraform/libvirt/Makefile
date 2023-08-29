all: private_ansible_cloud_init.pub
	terraform apply

private_ansible_cloud_init.pub:
	ssh-keygen -q -b 4096 -t rsa -N '' -f private_ansible_cloud_init

base:
	sudo ./virt-cloud-builder.sh

clean:
	- terraform destroy -auto-approve
	- virsh destroy lfs_control_plane_vm
	- virsh undefine lfs_control_plane_vm
	- virsh vol-delete lfs_control_plane_commoninit.iso
	- sleep 5 && sudo rm /var/lib/libvirt/images/lfs_control_plane_commoninit.iso
