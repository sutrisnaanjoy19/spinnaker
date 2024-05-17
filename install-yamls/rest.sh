helm upgrade misc-nginx ingress-nginx/ingress-nginx --values misc-nginx-ingress.yaml -n monitoring

hal deploy apply
#deleting an account
hal config provider kubernetes account delete spinnaker-account-poc --no-validate
#add another kubernetes cluster 
echo "Configuring k8s additional accounts"
hal config provider kubernetes account add apse1-kube \
--context CONTEXT_NAME --kubeconfig-file /home/sutrisna/spinnaker/secrets/kubeconfig-poc.yaml \
--omit-namespaces kube-system,kube-public,kube-node-lease,misc-nginx,opencost,monitoring,pvm-control,spring-nginx --provider-version v2

#enabling oauth before that please create a oauth credential in GCP
hal config security authn oauth2 edit --provider google \
  --client-id CLIENT_ID \
  --client-secret CLIENT_SECRET

hal config security authn oauth2 enable

hal config security authn oauth2 edit --pre-established-redirect-uri http://spinnaker-api.use1-poc-gke.srv.media.net/

#gitlab integration
TOKEN_FILE="/home/sutrisna/Desktop/spinnaker-gitlab/spinnaker/secrets/gitlab-token"

ARTIFACT_ACCOUNT_NAME=sutrishna-gitlab-account
hal config artifact gitlab enable
hal config artifact gitlab account add $ARTIFACT_ACCOUNT_NAME \
    --token-file $TOKEN_FILE

#artifact registry plugin
PASSWORD_FILE="PASSWORD_JSON"
ADDRESS=us-docker.pkg.dev
REPOSITORIES="REPO_NAME"
hal config provider docker-registry enable
hal config provider docker-registry account add artifact-registry \
 --address $ADDRESS \
 --username _json_key \
 --repositories $REPOSITORIES \
 --password-file $PASSWORD_FILE

#gcr plugin

PASSWORD_FILE="PASSWORD_JSON"
ADDRESS=gcr.io
REPOSITORIES="REPO_NAME_PATH"

hal config provider docker-registry enable
hal config provider docker-registry account add google-container-registry \
 --address $ADDRESS \
 --username _json_key \
 --repositories $REPOSITORIES \
 --password-file $PASSWORD_FILE

#scale your deployments deck,gate and front
kubectl scale deployment/spin-gate deployment/spin-deck deployment/spin-front50 --replicas=2 --cluster CLUSTER_NAME -n spinnaker