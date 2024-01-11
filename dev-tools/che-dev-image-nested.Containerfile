FROM registry.access.redhat.com/ubi9/ubi-minimal
ARG USER_HOME_DIR="/home/user"
ARG WORK_DIR="/projects"
ARG JAVA_PACKAGE=java-17-openjdk-devel
ARG TOOLS_IMAGE="che-my-dev-tools"
ARG TOOLS_IMAGE_TAG="latest"
ENV HOME=${USER_HOME_DIR}
ENV BUILDAH_ISOLATION=chroot
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV GRAALVM_HOME=/usr/local/tools/graalvm
ENV JAVA_HOME=/etc/alternatives/jre_17_openjdk
ENV PATH=${PATH}:/usr/local/tools/bin:/usr/local/tools/node/bin
ENV JBANG_DIR=/usr/local/tools/jbang
COPY --from=quay.io/cgruver0/che/${TOOLS_IMAGE}:${TOOLS_IMAGE_TAG} /tools/ /usr/local/tools
COPY --chown=0:0 entrypoint.sh /
RUN microdnf --disableplugin=subscription-manager install -y procps-ng openssl compat-openssl11 libbrotli git tar gzip zip xz unzip which shadow-utils bash zsh vi wget jq podman buildah skopeo podman-docker glibc-devel zlib-devel gcc libffi-devel libstdc++-devel gcc-c++ glibc-langpack-en ca-certificates python3-pip python3-devel ${JAVA_PACKAGE}; \
  microdnf update -y ; \
  microdnf clean all ; \
  mkdir -p ${USER_HOME_DIR} ; \
  mkdir -p ${WORK_DIR} ; \
  mkdir -p /usr/local/bin ; \
  npm install -g @angular/cli ; \
  npm install -g serverless ; \
  setcap cap_setuid+ep /usr/bin/newuidmap ; \
  setcap cap_setgid+ep /usr/bin/newgidmap ; \
  mkdir -p ${HOME}/.config/containers ; \
  mkdir ${HOME}/proc ; \
  (echo '[containers]';echo 'netns="private"';echo 'default_sysctls = []';echo '[engine]';echo 'network_cmd_options=[';echo '  "enable_ipv6=false"';echo ']') > ${HOME}/.config/containers/containers.conf ; \
  (echo 'unqualified-search-registries = [';echo '  "docker.io"'; echo ']'; echo 'short-name-mode = "permissive"') > ${HOME}/.config/containers/registries.conf ; \
  touch /etc/subgid /etc/subuid ; \
  chmod -R g=u /etc/passwd /etc/group /etc/subuid /etc/subgid ; \
  echo user:20000:65536 > /etc/subuid  ; \
  echo user:20000:65536 > /etc/subgid ; \
  TEMP_DIR="$(mktemp -d)" ; \
  curl -fsSL -o ${TEMP_DIR}/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip ; \
  unzip ${TEMP_DIR}/awscliv2.zip -d ${TEMP_DIR} ; \
  ${TEMP_DIR}/aws/install ; \
  rm -rf "${TEMP_DIR}" ; \
  TEMP_DIR="$(mktemp -d)" ; \
  curl -fsSL -o ${TEMP_DIR}/localstack.tgz https://github.com/localstack/localstack-cli/releases/download/v2.2.0/localstack-cli-2.2.0-linux-amd64-onefile.tar.gz ; \
  tar -xzf ${TEMP_DIR}/localstack.tgz -C /usr/local/bin ; \
  rm -rf "${TEMP_DIR}" ; \
  pip3 install ansible-navigator ; \
  pip3 install ansible ; \
  pip3 install ansible-lint ; \
  pip3 install aws-sam-cli ; \
  pip3 install awscli-local ; \
  mkdir -p ${JBANG_DIR} ; \
  curl -Ls https://sh.jbang.dev | bash -s - app setup ; \
  ln -s ${JBANG_DIR}/bin/jbang /usr/local/tools/bin/jbang ; \
  chgrp -R 0 /home ; \
  chmod +x /entrypoint.sh ; \
  chmod -R g=u /home ${WORK_DIR}
USER 10001
WORKDIR ${WORK_DIR}
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
