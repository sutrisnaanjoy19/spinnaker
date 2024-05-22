# SERVICE_ACCOUNT_NAME=spinnaker-gcs-account
# SERVICE_ACCOUNT_DEST=~/.gcp/gcs-account.json

# gcloud iam service-accounts create \
#     $SERVICE_ACCOUNT_NAME \
#     --display-name $SERVICE_ACCOUNT_NAME

# SA_EMAIL=$(gcloud iam service-accounts list \
#     --filter="displayName:$SERVICE_ACCOUNT_NAME" \
#     --format='value(email)')

# PROJECT=$(gcloud config get-value project)

# gcloud projects add-iam-policy-binding $PROJECT \
#     --role roles/storage.admin --member serviceAccount:$SA_EMAIL

# mkdir -p $(dirname $SERVICE_ACCOUNT_DEST)

# gcloud iam service-accounts keys create $SERVICE_ACCOUNT_DEST \
#     --iam-account $SA_EMAIL

#/home/sutrisna/.gcp/gcs-account.json

PROJECT=$(gcloud config get-value project)
# see https://cloud.google.com/storage/docs/bucket-locations
BUCKET_LOCATION=us
BUCKET=spinnaker-BUCKET
SERVICE_ACCOUNT_DEST="/home/sutrisna/spinnaker/secrets/[FILE.JSON]"
hal config storage gcs edit --project ${PROJECT} \
    --bucket-location ${BUCKET_LOCATION} \
    --json-path ${SERVICE_ACCOUNT_DEST} \
    --bucket ${BUCKET} 
hal config storage edit --type gcs
