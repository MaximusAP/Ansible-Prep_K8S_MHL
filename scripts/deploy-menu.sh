#!/bin/bash

INVENTORY="inventory/hosts.ini"
PLAYBOOK_DIR="playbooks"

function pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

function run_playbook(){
  PLAYBOOK=$1

  echo "=================================================="
  echo "Running: $PLAYBOOK"
  echo "=================================================="

  ansible-playbook -i $INVENTORY $PLAYBOOK_DIR/$PLAYBOOK

  if [ $? -eq 0 ]; then
    echo "SUCCESS: $PLAYBOOK completed"
  else
    echo "FAILED: $PLAYBOOK"
    exit 1
  fi

  pause
}

while true
 do

clear

echo "==============================================="
echo " Kubernetes Home Lab Deployment Menu"
echo "==============================================="
echo ""
echo "1. Common OS Configuration"
echo "2. Install Containerd"
echo "3. Install Kubernetes Packages"
echo "4. Initialize Kubernetes Cluster"
echo "5. Join Additional Masters"
echo "6. Join Worker Nodes"
echo "7. Install Calico CNI"
echo "8. Install MetalLB"
echo "9. Install ingress-nginx"
echo "10. Install Rancher"
echo "11. Install Monitoring Stack"
echo "12. Run Full Deployment"
echo "0. Exit"
echo ""

read -p "Select an option: " option

case $option in

1)
  run_playbook "01-common.yml"
  ;;

2)
  echo "Containerd playbook placeholder"
  pause
  ;;

3)
  echo "Kubernetes packages playbook placeholder"
  pause
  ;;

12)
  run_playbook "01-common.yml"
  ;;

0)
  echo "Exiting..."
  exit 0
  ;;

*)
  echo "Invalid option"
  pause
  ;;

esac

done
