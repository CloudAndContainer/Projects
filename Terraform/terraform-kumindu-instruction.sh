 #!/bin/bash
echo "###########################################################################################"
echo "                                    Terraform installation                                 "
echo " @Author Kumindu Induranga Ranawaka @Case:fa520ace27209ade1268603f8a17ad86        01/03/20 "
echo "###########################################################################################"
echo
git clone https://github.com/WesleyCharlesBlake/terraform-aws-eks.git

cd terraform-aws-eks

cat >> provider.tf << EOF
provider "aws" {
  region     = "${var.aws_region}"
  profile    = "eks"
}
EOF

read -p "Please enter your aws region" region
cat >> vars.tf << EOF
variable "aws_region" {
  description = "US EAST Virginia"
  default     = "$region"
}
EOF
echo
sudo apt-get update
echo "TerraForm Download"
wget https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
sudo apt-get install unzip
echo "TerraForm Installation Started"
sudo unzip ./terraform_0.11.13_linux_amd64.zip -d /usr/local/bin/
terraform -v
echo "TerraForm Installation Completed"
echo
echo "Installation awscli start"
sudo apt install awscli
echo "Installation awscli completed"
echo
echo "aws-iam-authenticator installation start"
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator
echo "aws-iam-authenticator installation compeleted"
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
aws-iam-authenticator help
read -p "Please enter your AWS_ACCESS_KEY_ID" AWS_ACCESS_KEY_ID
read -p "Please enter your AWS_SECRET_ACCESS_KEY_HERE" AWS_SECRET_ACCESS_KEY
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
terraform init
read -p "Please enter your cluster name" clusterName
read -p "Please enter number of node:" nodeCount
terraform plan -var 'cluster-name='.$clusterName -var 'desired-capacity='.$nodeCount -out $clusterName
echo "cluster creating started"
terraform apply $clusterName
