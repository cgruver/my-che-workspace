TEMP_DIR="$(mktemp -d)"
curl -fsSL -o ${TEMP_DIR}/kn.tgz http://knative-openshift-metrics-3.openshift-serverless.svc.cluster.local:8080/kn-linux-amd64.tar.gz
tar -zxf ${TEMP_DIR}/kn.tgz -C ${PROJECTS_ROOT}/bin
rm -rf "${TEMP_DIR}"