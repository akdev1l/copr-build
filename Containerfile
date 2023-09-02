FROM fedora:38

RUN dnf install -y copr-cli

COPY copr-build /usr/local/bin/copr-build
