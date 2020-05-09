FROM gcr.io/cloud-builders/gcloud

ARG HELM_VERSION=3.1.2

COPY helm.sh /builder/helm.sh
COPY bootstrap.sh /builder/bootstrap.sh

RUN set -x ; chmod +x /builder/helm.sh && \
  mkdir -p /builder/helm && \
  apt-get update && \
  apt-get install -y curl sudo && \
  curl -SL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
  tar zxvf helm.tar.gz --strip-components=1 -C /builder/helm linux-amd64 && \
  rm helm.tar.gz && \
  apt-get --purge -y autoremove && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*

ENV PATH=/builder/helm/:$PATH
ENV TILLER_NAMESPACE=kube-system
ENV TILLERLESS=true
ENV HELM_CHART_DIR=.

ENTRYPOINT ["/builder/helm.sh"]
