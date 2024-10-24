#!/bin/bash

# Define the namespace to look into. Change this to the namespace containing your pods.
NAMESPACE=my-namespace

# Generate a temporary file for the ansible hosts
INVENTORY_FILE=$(mktemp /tmp/ansible-inventory.XXXXXX)
echo "[aks_containers]" > "$INVENTORY_FILE"

# Loop over each pod in the namespace
kubectl get pods -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}' | tr " " "\n" | while read -r pod_name; do
    # For each pod, extract the IP address
    pod_ip=$(kubectl get pod "$pod_name" -n "$NAMESPACE" -o jsonpath='{.status.podIP}')
    
    # Append the pod name and its IP to the Ansible inventory file
    echo "$pod_name ansible_host=$pod_ip" >> "$INVENTORY_FILE"
done

# At this point, $INVENTORY_FILE contains your dynamic inventory.
# For debugging or manual inspection, you might want to cat or less the file,
# e.g., uncomment the next line
# cat "$INVENTORY_FILE"

# Now you can use the inventory file with ansible-playbook
# Example: ansible-playbook -i "$INVENTORY_FILE" your-playbook.yml

# Cleanup or leaving the temporary file can be decided based on your use case
# rm "$INVENTORY_FILE"

