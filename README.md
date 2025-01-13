# Proxmox Sliver C2 Server Deployment

This repository contains Terraform configurations for deploying a Sliver Command & Control (C2) server on Proxmox VE.

## Prerequisites

- Proxmox VE server
- Terraform installed on your local machine
- Ubuntu cloud image template in Proxmox
- SSH key pair for authentication

## Template Setup

1. Download Ubuntu cloud image:
```bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

2. Install required tools:
```bash
sudo apt install p7zip-full libguestfs-tools
```

3. Customize the image:
```bash
virt-customize -a jammy-server-cloudimg-amd64.img \
  --root-password password:your_root_password \
  --password ubuntu:password:ubuntu \
  --run-command 'mkdir -p /root/.ssh' \
  --run-command 'chmod 700 /root/.ssh' \
  --run-command 'sed -i "s/^#PermitRootLogin .*/PermitRootLogin yes/" /etc/ssh/sshd_config' \
  --run-command 'sed -i "s/^PasswordAuthentication .*/PasswordAuthentication yes/" /etc/ssh/sshd_config' \
  --run-command 'sed -i "s/^#PubkeyAuthentication .*/PubkeyAuthentication yes/" /etc/ssh/sshd_config' \
  --run-command 'echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu' \
  --run-command 'truncate -s 0 /etc/machine-id' \
  --run-command 'ln -s /etc/machine-id /var/lib/dbus/machine-id' \
  --run-command 'systemctl enable ssh'
```

4. Create and configure VM template:
```bash
qm create 500 --memory 4096 --core 2 --name ubuntu-template --net0 virtio,bridge=vmbr0
qm importdisk 500 jammy-server-cloudimg-amd64.img local-lvm
qm set 500 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-500-disk-0
qm set 500 --ide2 local-lvm:cloudinit
qm set 500 --ipconfig0 ip=dhcp
qm set 500 --ciuser ubuntu
qm set 500 --cipassword ubuntu
qm set 500 --boot c --bootdisk scsi0
qm set 500 --agent enabled=1
qm set 500 --vga std
qm set 500 --ostype l26
qm template 500
```

## Usage

1. Clone this repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Create a `terraform.tfvars` file with your configuration:
```hcl
pm_api_url = "https://your-proxmox:8006/api2/json"
pm_api_token_id = "your-token-id"
pm_api_token_secret = "your-token-secret"
target_node = "your-node-name"
template_name_ubuntu = "ubuntu-template"
public_ssh_key = "path/to/your/public/key"
private_ssh_key = "path/to/your/private/key"
```

3. Initialize Terraform:
```bash
terraform init
```

4. Apply the configuration:
```bash
terraform plan
terraform apply
```

## Default Credentials

- Ubuntu user: `ubuntu:ubuntu`
- Root access: Available via `sudo` (no password required)
- SSH: Configured for both password and key-based authentication

## Security Notes

- Remember to change default passwords after deployment
- Consider disabling password authentication after initial setup
- Secure your Proxmox API tokens
- Keep your SSH keys safe

## License

MIT 