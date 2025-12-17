FROM alpine:3.20

# Instala Java + JMeter
RUN apk add --no-cache openjdk17 wget unzip bash && \
    mkdir -p /opt/jmeter && \
    wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz -O /tmp/jmeter.tgz && \
    tar -xzf /tmp/jmeter.tgz -C /opt/jmeter --strip-components=1 && \
    rm -rf /tmp/jmeter.tgz

ENV JMETER_HOME=/opt/jmeter
ENV PATH="$PATH:$JMETER_HOME/bin"

# Diretórios
RUN mkdir -p /tests-plans /scripts /reports /tests/data

# Scripts JMeter
COPY scripts/ /scripts/
RUN chmod -R 755 /scripts

WORKDIR /tests

ENTRYPOINT ["/scripts/run-tests.sh"]
