#editing spinnaker endpoint
hal config security ui edit \
    --override-base-url http://spinnaker.spinnaker.cluster.local
hal config security api edit \
    --override-base-url http://spinnaker-api.spinnaker.cluster.local
hal config security api edit \
    --cors-access-pattern http://spinnaker.spinnaker.cluster.local