# Kubernetes Home Lab Ansible Deployment

This repository configures Kubernetes and platform applications after Terraform has already provisioned the VMware VMs, static IPs, and HAProxy/Keepalived load balancer.

## Design

```text
Terraform = VM + Network + Static IP + Load Balancer provisioning
Ansible   = Kubernetes + Application deployment
```

## IP Plan

| Node | IP |
|---|---|
| lb-01 | 192.168.2.109 |
| lb-02 | 192.168.2.110 |
| k8s-master-01 | 192.168.2.111 |
| k8s-master-02 | 192.168.2.112 |
| k8s-master-03 | 192.168.2.113 |
| k8s-worker-01 | 192.168.2.114 |
| k8s-worker-02 | 192.168.2.115 |
| k8s-worker-03 | 192.168.2.116 |
| k8s-worker-04 | 192.168.2.117 |
| rancher-01 | 192.168.2.118 |
| monitoring-01 | 192.168.2.119 |
| mgmt-ws | 192.168.2.120 |
| k8s-api-vip | 192.168.2.123 |

## Folder Structure

```text
k8s-ansible/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
├── group_vars/
│   └── all.yml
├── playbooks/
│   ├── 01-common.yml
│   ├── 02-containerd.yml
│   ├── 03-kubernetes.yml
│   ├── 04-init-cluster.yml
│   ├── 05-join-masters.yml
│   ├── 06-join-workers.yml
│   ├── 07-install-calico.yml
│   ├── 08-install-metallb.yml
│   ├── 09-install-ingress-nginx.yml
│   ├── 10-install-rancher.yml
│   ├── 11-install-monitoring.yml
│   └── 12-verify-cluster.yml
└── README.md
```

## Prerequisites

Run from your management workstation or Mac where Ansible can SSH to all nodes.

```bash
ansible --version
ssh admin@192.168.2.111
```

Make sure passwordless sudo or SSH key authentication is working for the `admin` user.

## Execution Order

```bash
cd k8s-ansible

ansible-playbook playbooks/01-common.yml
ansible-playbook playbooks/02-containerd.yml
ansible-playbook playbooks/03-kubernetes.yml
ansible-playbook playbooks/04-init-cluster.yml
ansible-playbook playbooks/05-join-masters.yml
ansible-playbook playbooks/06-join-workers.yml
ansible-playbook playbooks/07-install-calico.yml
ansible-playbook playbooks/08-install-metallb.yml
ansible-playbook playbooks/09-install-ingress-nginx.yml
ansible-playbook playbooks/10-install-rancher.yml
ansible-playbook playbooks/11-install-monitoring.yml
ansible-playbook playbooks/12-verify-cluster.yml
```

## Notes

- `k8s-master-01` is used as the first control-plane node.
- The Kubernetes API endpoint is `192.168.2.123:6443`.
- MetalLB IP range is `192.168.2.130-192.168.2.140`.
- Calico is used as the CNI.
- Rancher hostname is configured as `rancher.local`; update DNS or `/etc/hosts` as needed.

## Interview Explanation

I separated infrastructure provisioning and configuration management. Terraform provisions the VMware VMs, static IPs, and load balancer. Ansible handles Kubernetes and application deployment, including OS prerequisites, containerd, kubeadm, kubelet, kubectl, HA control-plane initialization, worker joins, Calico, MetalLB, ingress-nginx, Rancher, and monitoring.
