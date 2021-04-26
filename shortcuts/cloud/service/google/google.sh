#google

# https://github.com/tensorflow/cloud#cluster-and-distribution-strategy-configuration
# https://www.tensorflow.org/api_docs/python/tf/distribute/OneDeviceStrategy
# https://www.tensorflow.org/guide/distributed_training
# https://colab.research.google.com/notebooks/intro.ipynb

# https://github.com/tensorflow/cloud#setup-instructions

#which gcloud

#export PROJECT_ID=<your-project-id>
#gcloud config set project $PROJECT_ID

#export SA_NAME=<your-sa-name>
#gcloud iam service-accounts create $SA_NAME
#gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com --role 'roles/editor'
#gcloud iam service-accounts keys create ~/key.json --iam-account $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

#export GOOGLE_APPLICATION_CREDENTIALS=~/key.json

#BUCKET_NAME="your-bucket-name"
#REGION="us-central1"
#gcloud auth login
#gsutil mb -l $REGION gs://$BUCKET_NAME

#gcloud auth configure-docker






