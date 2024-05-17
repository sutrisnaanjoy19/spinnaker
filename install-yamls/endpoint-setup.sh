#editing spinnaker endpoint
hal config security ui edit \
    --override-base-url http://spinnaker.use1-poc-gke.srv.media.net
hal config security api edit \
    --override-base-url http://spinnaker-api.use1-poc-gke.srv.media.net
hal config security api edit \
    --cors-access-pattern http://spinnaker.use1-poc-gke.srv.media.net