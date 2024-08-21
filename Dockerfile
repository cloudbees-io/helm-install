FROM public.ecr.aws/l7o7z1g8/services/registry-config:0.0.22 as registry-config

FROM alpine/helm:3.15.2

RUN apk update && \
    apk add --no-cache yq

RUN apk upgrade --no-cache

ARG SKAFFOLD_VERSION=v2.13.1
RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/$SKAFFOLD_VERSION/skaffold-linux-$ARCH; \
	chmod +x /usr/local/bin/skaffold; \
	skaffold version

ARG K8S_VERSION=v1.28.4
RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/$K8S_VERSION/bin/linux/$ARCH/kubectl; \
	chmod +x /usr/local/bin/kubectl; \
	kubectl version --client

COPY fake-docker.sh /usr/bin/docker
COPY duration2seconds.sh /usr/local/bin/duration2seconds

COPY --from=registry-config /registry-config /usr/local/bin/registry-config

ENTRYPOINT ["bash"]
