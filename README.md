# [Elasticsearch](https://www.elastic.co/products/elasticsearch) [Docker Image](https://www.docker.elastic.co/) with integrated [elasticsearch-prometheus-exporter](https://github.com/vvanholl/elasticsearch-prometheus-exporter) plugin

[![](https://images.microbadger.com/badges/version/xtermi2/sec-elasticsearch-prometheus.svg)](https://microbadger.com/images/xtermi2/sec-elasticsearch-prometheus)
[![](https://images.microbadger.com/badges/image/xtermi2/sec-elasticsearch-prometheus.svg)](https://microbadger.com/images/xtermi2/sec-elasticsearch-prometheus)
[![](https://images.microbadger.com/badges/commit/xtermi2/sec-elasticsearch-prometheus.svg)](https://microbadger.com/images/xtermi2/sec-elasticsearch-prometheus)
[![Build Status](https://travis-ci.org/xtermi2/sec-elasticsearch-prometheus.svg?branch=master)](https://travis-ci.org/xtermi2/sec-elasticsearch-prometheus)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/b2a9a55db2b245c4b0e69e21b9e196b6)](https://app.codacy.com/app/xtermi2/sec-elasticsearch-prometheus?utm_source=github.com&utm_medium=referral&utm_content=xtermi2/sec-elasticsearch-prometheus&utm_campaign=Badge_Grade_Dashboard)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu)

For a complete example with 2 elasticsearch nodes, [kibana](https://www.elastic.co/products/kibana), 
[prometheus](https://prometheus.io) and [grafana](https://grafana.com) have a look at
 [xtermi2/sec-elasticsearch-prometheus/example/README.md](https://github.com/xtermi2/sec-elasticsearch-prometheus/tree/master/example)

## Image detail description

This docker image extends the original elastic image, sets up default user passwords and installs [elasticsearch-prometheus-exporter](https://github.com/vvanholl/elasticsearch-prometheus-exporter) plugin. 

At startup elasticsearch is configured with a set of [default users](https://www.elastic.co/guide/en/elastic-stack-overview/current/built-in-users.html):

-   elastic: A admin user which has no restrictions
-   kibana: The user Kibana uses to connect and communicate with Elasticsearch.
-   beats_system: The user the Beats use when storing monitoring information in Elasticsearch.
-   logstash_system: The user Logstash uses when storing monitoring information in Elasticsearch.
-   apm_system: The user the APM server uses when storing monitoring information in Elasticsearch.
-   remote_monitoring_user: The user Metricbeat uses when collecting and storing monitoring information in Elasticsearch.

This image also adds:
 
-   a user named `beats`, which has the same roles as the default beats_system user and will have the same password. So it's like an alias.
-   a user named `kibana_user`, which has roles `kibana_user`, `reporting_user` and `kibana_admin` and is designed to login to Kibana UI.
    [kibana_admin](https://github.com/xtermi2/sec-elasticsearch-prometheus/tree/master/src/main/resources/config/roles.yml) is a custom role, which grants admin rights for kibana and read access to all indices.

You are able to easily set passwords for these users via Docker environment variables.

This image is only usable securely and therefore requires certificates. In this image you need 2 types:

-   a CA certificate, which signed the other certificate.
-   a certificate + private key for the elasticsearch nodes which is used at REST and transport API.

These Certificates have to be mounted in the container at `/usr/share/elasticsearch/config/certificates/` and must be [configured](#x-pack-security-configuration) 

## [File Descriptors and MMap](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

Elasticsearch uses a mmapfs directory by default to store its indices. The default operating system limits on mmap counts is likely to be too low, which may result in out of memory exceptions.
The host has to run this command:

```bash
sudo sysctl -w vm.max_map_count=262144
```

You can set it permanently by modifying `vm.max_map_count` setting in your `/etc/sysctl.conf`.

## Environment Configuration

- Passwords: All passwords are unset at default, so, if a password is not explicitly defined, the corresponding user is not available/usable! 
  - **ELASTIC_PASSWORD**: The password of the pre defined admin user '**elastic**'.
  - **KIBANA_PASSWORD**: The password of the pre defined '**kibana**' user. This user is used and configured only in `kibana.yml` and has `kibana_system` role.
  - **KIBANA_USER_PASSWORD**: The password of the '**kibana_user**' user. This user is used to login to Kibana UI and has `kibana_user` role
  - **BEATS_PASSWORD**: The password of the pre defined '**beats**'/'**beats_system**' user.
  - **LOGSTASH_PASSWORD**: The password of the pre defined '**logstash_system**' user.
  - **APM_PASSWORD**: The password of the pre defined '**apm_system**' user.
  - **REMOTE_MONITORING_PASSWORD**: The password of the pre defined '**remote_monitoring_user**' user.

### X-Pack security configuration

You also have to set the elasticsearch related TLS/security [configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html).
Have a look at the example [docker-compose.yml](https://github.com/xtermi2/sec-elasticsearch-prometheus/tree/master/example/docker-compose.yml) for an impression.

## User Feedback

### Issues

If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/xtermi2/sec-elasticsearch-prometheus/issues).
