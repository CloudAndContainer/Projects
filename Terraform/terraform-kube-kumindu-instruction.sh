 #!/bin/bash
echo "###########################################################################################"
echo "                                    Terraform Kube installation                            "
echo " @Author Kumindu Induranga Ranawaka @Case:fa520ace27209ade1268603f8a17ad86        01/03/20 "
echo "###########################################################################################"
echo
terraform output kubeconfig
echo
terraform output kubeconfig > ${HOME}/.kube/config-eks-demo-cluster-tf
echo
export KUBECONFIG=${HOME}/.kube/config-eks-demo-cluster-tf:${HOME}/.kube/config
echo
echo "export KUBECONFIG=${KUBECONFIG}" >> ${HOME}/.bash_profile
echo
read -p "Please enter your cluster name" clusterName
aws eks update-kubeconfig --name $clusterName
echo
terraform output config-map > /tmp/config-map-aws-auth.yml
echo
kubectl apply -f /tmp/config-map-aws-auth.yml
kubectl get nodes
echo
kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true
echo
terraform plan -destroy -out eks-demo-cluster-destroy-tf
echo
terraform apply  $clusterName
echo 
