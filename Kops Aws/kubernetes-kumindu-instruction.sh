 #!/bin/bash
echo "###########################################################################################"
echo "                                    Kubernetes installation                                "
echo " @Author Kumindu Induranga Ranawaka @Case:fa520ace27209ade1268603f8a17ad86        01/03/20 "
echo "###########################################################################################"
echo
sudo apt-get update
echo "Installation SSH start"
ssh-keygen
echo "Installation SSH completed"
sudo apt-get update
echo "Installation awscli start"
sudo apt install awscli
echo "Installation awscli completed"
echo
sudo chmod 777 -R /home/ubuntu/.aws/credentials
sudo chmod 777 -R /home/ubuntu/.aws/config
echo "Config aws using AWS_ACCESS_KEY_ID && AWS_SECRET_ACCESS_KEY"
aws configure
echo "Kubernetes downloading start"
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
echo "Kubernetes dowloaded"
sudo chmod +x ./kubectl
echo "Kubernetes path configaration start"
sudo mv ./kubectl /usr/local/bin/kubectl
echo "Kubernetes path configaration completed"
echo
echo "Kops downloading start"
sudo curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
echo "Kops dowloaded"
sudo chmod +x kops-linux-amd64
echo "Kops path configaration start"
sudo mv kops-linux-amd64 /usr/local/bin/kops
echo "Kubernetes path configaration completed"
read -p "Please enter your S3 bucket Name  :" s3Name
read -p "Please enter your S3 bucket region[us-east-1]:" regionName
aws s3api create-bucket --bucket $s3Name-kops-state-store --region $regionName
aws s3api put-bucket-versioning --bucket $s3Name-kops-state-store  --versioning-configuration Status=Enabled
read -p "Please enter your kops cluster name:" clusterName
export KOPS_CLUSTER_NAME=$clusterName.k8s.local
export KOPS_STATE_STORE=s3://$s3Name-kops-state-store
echo "S3 Bucket Configaration Completed"
echo
echo "Kubernetes cluster initialization start"
echo
read -p "Please enter number of node:" nodeCount
read -p "Please enter node type [t2.medium]:" nodeType
read -p "Please enter your node loacting region[us-east-1a]:" nodeZones
kops create cluster --node-count=2 --node-size=t2.medium --zones=us-east-1a
echo "Adding SSH to ".$clusterName.k8s.local
kops create secret --name $clusterName.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub
echo
kops update cluster --name ${KOPS_CLUSTER_NAME} --yes
echo "cluster creating started........."


