FROM neo4j:3.1.5

ENV PKGS="curl bash openssh-client jq"

ENV PATH /var/lib/neo4j/bin:$PATH

RUN apk --no-cache upgrade && \
    apk --no-cache add $PKGS

WORKDIR /working

COPY . /working

# Put configuration in place
COPY neo4j.write.conf /var/lib/neo4j/conf/neo4j.conf

WORKDIR /var/lib/neo4j

RUN neo4j start && \
    sleep 15 && \
    sh /working/load_json.sh organization-chart && \
    sh /working/load_json.sh source-code-control && \
    sh /working/load_json.sh dataflow-diagram && \
    neo4j stop

# Put configuration in place
COPY neo4j.conf /var/lib/neo4j/conf/
