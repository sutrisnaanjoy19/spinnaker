#!/bin/bash
CONTEXT=$(kubectl config current-context)
hal config provider kubernetes account delete spinnaker-account-poc --no-validate
# this service account uses the ClusterAdmin role -- this is not necessary, more restrictive roles can by applied.
kubectl apply --context ${CONTEXT} -f rbac-serviceaccount.yaml
# get service token
# TOKEN=$(kubectl get secret --cluster ${CONTEXT} \
#    $(kubectl get serviceaccount spinnaker-service-account \
#        --cluster ${CONTEXT} \
#        -n spinnaker \
#        -o jsonpath='{.secrets[0].name}') \
#    -n spinnaker \
#    -o jsonpath='{.data.token}' | base64 --decode)
#create a secret associated with your serviceaccount using serviceaccount-secret.yaml and copy the token.
TOKEN="YOUR_TOKEN"
# set credentials
kubectl config set-credentials ${CONTEXT}-token-user --token ${TOKEN}
# set context
kubectl config set-context ${CONTEXT} --user ${CONTEXT}-token-user
# add in provider account
#hal config provider kubernetes account add spinnaker-account-poc --provider-version v2 --context ${CONTEXT}
#create a new config file for your token user and add that
hal config provider kubernetes account add spinnaker-account-poc --provider-version v2 \
--kubeconfig-file "/home/sutrisna/spinnaker/secrets/kubeconfig-poc.yaml" \
--context $(kubectl config current-context --kubeconfig "/home/sutrisna/spinnaker/secrets/kubeconfig-poc.yaml") \
--omit-namespaces kube-system,kube-public,kube-node-lease,misc-nginx,opencost,monitoring,pvm-control,spring-nginx
# enable kubernetes
hal config provider kubernetes enable
# finally enable artifacts
hal config features edit --artifacts true
# add your version
hal config version edit --version 1.32.3
# set the account to install spinnaker into
ACCOUNT=spinnaker-account-poc
# install spinnaker
hal config deploy edit --type distributed --account-name $ACCOUNT