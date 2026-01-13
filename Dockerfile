FROM public.ecr.aws/l7o7z1g8/actions/registry-config:0.0.76 AS registry-config

FROM alpine/helm:3.18.6

RUN set -eux; \
    apk add --no-cache yq; \
    apk upgrade --no-cache; \
    apk upgrade --no-cache pcre2

ARG SKAFFOLD_VERSION=v2.16.1

RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/$SKAFFOLD_VERSION/skaffold-linux-$ARCH; \
	chmod +x /usr/local/bin/skaffold; \
	skaffold version

ARG K8S_VERSION=v1.33.4
RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/$K8S_VERSION/bin/linux/$ARCH/kubectl; \
	chmod +x /usr/local/bin/kubectl; \
	kubectl version --client

# Bump argo-rollouts version to latest rc to pick up CVE-2024-45337 fix
ARG ARGO_ROLLOUT_PLUGIN_VERSION=v1.9.0-rc3
RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/kubectl-argo-rollouts https://github.com/argoproj/argo-rollouts/releases/download/$ARGO_ROLLOUT_PLUGIN_VERSION/kubectl-argo-rollouts-linux-$ARCH; \
	chmod +x /usr/local/bin/kubectl-argo-rollouts; \
	kubectl-argo-rollouts version \

## # Remove wget - CVE-2024-38428 
RUN apk del wget

COPY fake-docker.sh /usr/bin/docker
COPY duration2seconds.sh /usr/local/bin/duration2seconds

COPY --from=registry-config /registry-config /usr/local/bin/registry-config

ENTRYPOINT ["bash"]
