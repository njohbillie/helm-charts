FROM ansible/ansible-runner:latest

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install necessary packages and Python libraries
RUN dnf install -y sshpass openssh-clients && \
    pip install kubernetes openshift

# Install Ansible collections for Kubernetes and Azure
RUN ansible-galaxy collection install community.kubernetes && \
    ansible-galaxy collection install azure.azcollection

# Copy the script into the container
COPY generate_inventory.sh /usr/local/bin/generate_inventory.sh
RUN chmod +x /usr/local/bin/generate_inventory.sh

CMD ["/bin/bash"]
