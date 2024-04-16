FROM docker.io/library/alpine:latest As alpine-builder
COPY gcc_setup.sh /opt/gcc_setup.sh
RUN chmod u+x /opt/gcc_setup.sh
RUN /opt/gcc_setup.sh

FROM scratch AS build-output
COPY --from=alpine-builder /app /app
