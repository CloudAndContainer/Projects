 #!/bin/bash
echo "###########################################################################################"
echo "                                    Kubernetes installation                                "
echo " @Author Kumindu Induranga Ranawaka @Case:fa520ace27209ade1268603f8a17ad86        01/03/20 "
echo "###########################################################################################"
echo
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl cluster-info