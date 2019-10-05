# Here is described how to start the example

## Requirements

-   docker-compose installed
-   some basic unix tolls like _wget_, _unzip_, _curl_

## First get some certificates

Here is described how to generate self signed certificates, which is save for production. 
Details are described [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls-docker.html).

1.  In directory `example/cert-gen` is a pre-defined configuration for creating some certificates. 
    Create them with the following commands:
    ```bash
    cd example/cert-gen
    docker-compose -f create-certs.yml run --rm create_certs    
    ```
    -   `example/cert-gen/certs/ca/ca.crt`: is a self signed CA 
    -   `example/cert-gen/certs/node/node.crt`: is a certificate for all nodes
    -   `example/cert-gen/certs/node/node.key`: is the private key for the node certificate

## start elasticsearch, kibana, prometheus and grafana with docker-compose

1.  set required kernel flags (<https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html>)
    -   `sudo sysctl -w vm.max_map_count=262144`
        -   this setting is only temporary, to set this permanently add the parameter in `/etc/sysctl.conf`

2.  start docker-compose
    -   `docker-compose up`   

3.  test if elasticsearch cluster is up and running: 

    -   `curl -k -u 'elastic:elastic' https://localhost:9200/_cluster/health?pretty`
        -   you should see **status: green** and **number_of_nodes: 2**.

    -   `curl -k -u 'remote_monitoring_user:monitor' https://localhost:9200/_prometheus/metrics`
        -   here you can see raw prometheus metrics data.

4.  put a document to elasticsearch  
    ```bash
    curl -k -u 'elastic:elastic' -X PUT https://localhost:9200/myindex/_doc/1 -H 'Content-Type: application/json' -d '{"user" : "kimchy", "post_date" : "2009-11-15T14:12:12", "message" : "trying out Elasticsearch"}'
    ```

5.  try it out

    -   with kibana <http://localhost:5601> and login with `kibana_user:kibana`
        -   Add the previously created index "myindex" to kibana via **Management** -> **Index Patterns**.
        -   Now you are able to explore your elasticsearch index via kibana in the **Discover** view.

    -   with prometheus <http://localhost:9090/targets> to see all prometheus targets

    -   with grafana <http://localhost:3000> and login with `admin:admin`
        -   There exists a provisioned dashboard called "ElasticSearch" from <https://grafana.com/dashboards/266>
