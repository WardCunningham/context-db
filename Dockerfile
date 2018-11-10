FROM neo4j:3.1.5

ENV BUILD_PKGS="curl" \
    SUPPORT_PKGS="bash openssh-client"

ENV PATH /var/lib/neo4j/bin:$PATH

RUN apk --no-cache upgrade && \
    apk --no-cache add $BUILD_PKGS $SUPPORT_PKGS

RUN mkdir -p /working/scripts

WORKDIR /working

COPY . /working

# Put configuration in place
COPY neo4j.write.conf /var/lib/neo4j/conf/neo4j.conf

WORKDIR /var/lib/neo4j

RUN neo4j start && \
    sleep 10 && \
    sh /working/load_json.sh \
      'http://context.asia.wiki.org/plugin/json/organization-chart' \
      /working/import_org_chart.cypher && \
    neo4j stop

# Put configuration in place
COPY neo4j.conf /var/lib/neo4j/conf/
