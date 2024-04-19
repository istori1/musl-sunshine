FROM docker.io/library/alpine:latest As alpine-builder
COPY clang_setup.sh /opt/clang_setup.sh
RUN chmod u+x /opt/clang_setup.sh
RUN /opt/clang_setup.sh

FROM scratch AS build-output
COPY --from=alpine-builder /opt/sunshine /opt/sunshine
