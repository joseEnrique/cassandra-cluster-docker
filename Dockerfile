
# Podgroup Cassandra 3.11 Cluster Node Image
FROM cassandra:3.11
MAINTAINER Jose Enrique Ruiz Navarro, quique.ruiz@podgroup.com

ENV CASSANDRA_PASSWORD prueba
# Place cluster-node startup-config script
ADD scripts/cassandra-clusternode.sh /cassandra-clusternode.sh
ADD scripts/healthcheck /healthcheck


# Start Cassandra
ENTRYPOINT ["./cassandra-clusternode.sh"]
