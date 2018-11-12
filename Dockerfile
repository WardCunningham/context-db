FROM neo4j:3.1.5

RUN apk --no-cache upgrade && \
    apk --no-cache add curl jq

WORKDIR /working
COPY . /working

# Configure neo4j for read/write
COPY neo4j.write.conf /var/lib/neo4j/conf/neo4j.conf

WORKDIR /var/lib/neo4j
ENV PATH /var/lib/neo4j/bin:$PATH
RUN neo4j start && \
    sleep 15 && \
    cat /var/lib/neo4j/logs/neo4j.log && \
    echo ================================ && \
    sh /working/load_json.sh organization-chart && \
    sh /working/load_json.sh source-code-control && \
    sh /working/load_json.sh dataflow-diagram && \
    sh /working/load_json.sh service-traffic-reports && \
    echo ================================ && \
    neo4j stop

# Configure neo4j for read-only
COPY neo4j.conf /var/lib/neo4j/conf/
