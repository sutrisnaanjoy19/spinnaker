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
TOKEN="eyJhbGciOiJSUzI1NiIsImtpZCI6IjVFZnNOQUY2UkI4VXNJbWV0bEt5ZVVhT1B1Skx3bHFKUGtfMC1aZUg2WEkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJzcGlubmFrZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoic3Bpbm5ha2VyLXNlcnZpY2UtYWNjb3VudC10b2tlbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJzcGlubmFrZXItc2VydmljZS1hY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiM2NjNWIxNGYtMDc4NC00Y2RlLWIzMDMtNzFmMDgyMjJkN2ZkIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OnNwaW5uYWtlcjpzcGlubmFrZXItc2VydmljZS1hY2NvdW50In0.mLD0ruwZrB1WNCiIJuCAYRgiE_ASCunWsD6EIR8NNFvIDo8fVpWS5e2flJSLNkN0biPb0nAh57UxiUFrEWuuUfMH27zyprLM76651W9VZkjfAtD1Vh5_pyYbmODA4jgYTLJWB-vPZDs5x0CIbtzoGEkq7PiZBwxBzncSyBjjRLNpYIJBfkwVfJcHyaORLytudy5LZct-IRlgdOAtZmP2dk9mbGtk8Utedq2ASso0MT7sx245kcV99UIdqQj8t0SwioQ3KNqzW5Q7Ug_S5L1_DHIsuralDw-YT-9Yke_MidzgF-6szAYcB_wOOyKRWZ7imeX1iedIxdbtSdmHZQD2BQ"
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