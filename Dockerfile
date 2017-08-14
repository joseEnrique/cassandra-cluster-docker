
# Podgroup Cassandra 3.11 Cluster Node Image
#
# VERSION               0.1
#
# Expects CASSANDRA_SEEDS and CASSANDRA_TOKEN env variables to be set.
# If CASSANDRA_SEEDS is not set, node acts as its own seed
# If CASSANDRA_TOKEN is not set, startup process is aborted

FROM cassandra:3.11


# Place cluster-node startup-config script
ADD scripts/cassandra-clusternode.sh /cassandra-clusternode.sh
COPY ./cassandra.yaml /etc/cassandra/cassandra.yaml

CMD "bash"
# Start Cassandra
ENTRYPOINT ["./cassandra-clusternode.sh"]
