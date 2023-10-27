FROM alpine/helm:3.12.1

# Install aws-cli
RUN apk update && \
    apk add --no-cache aws-cli yq
