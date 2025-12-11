FROM alpine:latest

# Instala Java + JMeter
RUN apk update && \
    apk add openjdk17 wget unzip bash && \
    mkdir -p /opt/jmeter && \
    wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz -O /tmp/jmeter.tgz && \
    tar -xzf /tmp/jmeter.tgz -C /opt/jmeter --strip-components=1 && \
    rm -rf /tmp/jmeter.tgz

ENV JMETER_HOME=/opt/jmeter
ENV PATH="$PATH:$JMETER_HOME/bin"

# Pastas usadas pelos volumes
RUN mkdir -p /test-plans /scripts /reports /tests/data

WORKDIR /tests
