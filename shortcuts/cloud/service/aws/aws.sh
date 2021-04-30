#aws

# https://aws.amazon.com/blogs/machine-learning/running-distributed-tensorflow-training-with-amazon-sagemaker/
# https://horovod.ai/getting-started/

#horovodrun -np 16 -H server1:4,server2:4,server3:4,server4:4 python train.py


# https://nodered.org/docs/getting-started/aws
#eb create


# https://nodered.org/docs/getting-started/aws
#sudo npm install -g --unsafe-perm pm2
#pm2 start `which node-red` -- -v
#pm2 save
#pm2 startup


# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html#using-s3-commands-managing-buckets-creating
#aws s3 mb s3://bucket-name

# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
#aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html
#aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pe

# https://stackoverflow.com/questions/30809822/how-to-get-aws-command-line-interface-to-work-in-cygwin
# 'I had the same problem. I got around it by installing a new copy of AWSCLI within Cygwin. You first need to install the "curl" and "python" Cygwin packages, then you can install AWSCLI as follows:'
#curl -O https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
#pip install awscli
#hash -d aws














