#FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-16-buster
#FROM mcr.microsoft.com/devcontainers/base:ubuntu
FROM mcr.microsoft.com/vscode/devcontainers/universal


COPY library-scripts/github-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/github-debian.sh
