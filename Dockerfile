# Instructions to build this image
FROM docker.elastic.co/elasticsearch/elasticsearch:7.3.0

ARG VCS_REF
ARG BUILD_DATE

LABEL description="extended elasticsearch image with pre-installed elasticsearch-prometheus-exporter"
LABEL org.label-schema.name="sec-elasticsearch-prometheus"
LABEL org.label-schema.description="extended elasticsearch image with pre-installed elasticsearch-prometheus-exporter"
LABEL org.label-schema.usage="https://github.com/xtermi2/sec-elasticsearch-prometheus/tree/master/example"
LABEL org.label-schema.url="https://github.com/xtermi2/sec-elasticsearch-prometheus"
LABEL org.label-schema.vcs-url="https://github.com/xtermi2/sec-elasticsearch-prometheus"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE

ENV PROMETHEUS_EXPORTER_VERSION "7.3.0.0"

ENV ELASTIC_PASSWORD ""
ENV KIBANA_PASSWORD ""
ENV KIBANA_USER_PASSWORD ""
ENV BEATS_PASSWORD ""
ENV LOGSTASH_PASSWORD ""
ENV APM_PASSWORD ""
ENV REMOTE_MONITORING_PASSWORD ""

COPY --chown=1000:0 ./src/main/resources/bin /usr/local/bin
COPY --chown=1000:0 ./src/main/resources/config /usr/share/elasticsearch/config

RUN echo "===> Installing elasticsearch-prometheus-exporter..." \
    && chmod -R +x /usr/local/bin \
    && elasticsearch-plugin install -b https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/${PROMETHEUS_EXPORTER_VERSION}/prometheus-exporter-${PROMETHEUS_EXPORTER_VERSION}.zip

ENTRYPOINT ["/usr/local/bin/new-entrypoint.sh"]
# Dummy overridable parameter parsed by entrypoint
CMD ["eswrapper"]