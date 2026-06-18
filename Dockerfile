FROM --platform=$TARGETPLATFORM public.ecr.aws/l7o7z1g8/actions/registry-config@sha256:8bd8abe266ae447d3fd13de4bbac1acf52a1156b59a864f8eac6537e914c5807 AS registry-config

FROM alpine/helm:4.2.2

RUN set -eux; \
    apk add --no-cache yq; \
    apk upgrade --no-cache; \
    apk upgrade --no-cache pcre2

ARG SKAFFOLD_VERSION=v2.22.0

RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/$SKAFFOLD_VERSION/skaffold-linux-$ARCH; \
	chmod +x /usr/local/bin/skaffold; \
	skaffold version

ARG K8S_VERSION=v1.35.4
RUN set -eux; \
	ARCH="`uname -m | sed 's!x86_64!amd64!; s!aarch64!arm64!'`"; \
	wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/$K8S_VERSION/bin/linux/$ARCH/kubectl; \
	chmod +x /usr/local/bin/kubectl; \
	kubectl version --client

## # Remove wget - CVE-2024-38428 
RUN apk del wget

COPY fake-docker.sh /usr/bin/docker
COPY duration2seconds.sh /usr/local/bin/duration2seconds

COPY --from=registry-config /registry-config /usr/local/bin/registry-config

ENTRYPOINT ["bash"]
