#!/usr/bin/env bash

# Get running container's IP
IP=`hostname --ip-address | cut -f 1 -d ' '`
ALL='0.0.0.0'

exec cassandra -f -R


if [ $# == 1 ]; then SEEDS="$1,$IP";
else SEEDS="$IP"; fi
rm -rf /var/lib/cassandra/data/system/*
# Setup cluster name
if [ -z "$CASSANDRA_CLUSTERNAME" ]; then
        echo "No cluster name specified, preserving default one"
else
        sed -i -e "s/^cluster_name:.*/cluster_name: $CASSANDRA_CLUSTERNAME/" $CASSANDRA_CONFIG/cassandra.yaml
fi


if [ -z "$CASSANDRA_SNITCH" ]; then
        echo "No SNITCH specified, preserving default one"
else
        sed -i -e "s/^endpoint_snitch:.*/endpoint_snitch: $CASSANDRA_SNITCH/" $CASSANDRA_CONFIG/cassandra.yaml
fi


if [ -z "$CASSANDRA_BROADCAST" ]; then
        echo "No BROADCAST specified, by default it is disabled"
else
        sed -i -e "s/^\# broadcast_rpc_address: 1.2.3.4/broadcast_rpc_address: $CASSANDRA_BROADCAST/" $CASSANDRA_CONFIG/cassandra.yaml

fi



# Dunno why zeroes here
sed -i -e "s/^rpc_address.*/rpc_address: $ALL/" $CASSANDRA_CONFIG/cassandra.yaml

# Listen on IP:port of the container
sed -i -e "s/^listen_address.*/listen_address: /" $CASSANDRA_CONFIG/cassandra.yaml

# Configure Cassandra seeds
if [ -z "$CASSANDRA_SEEDS" ]; then
	echo "No seeds specified, being my own seed..."
	CASSANDRA_SEEDS=$SEEDS
fi
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$CASSANDRA_SEEDS\"/" $CASSANDRA_CONFIG/cassandra.yaml

# With virtual nodes disabled, we need to manually specify the token
if [ -z "$CASSANDRA_TOKEN" ]; then
	echo "Missing initial token for Cassandra"
	exit -1
fi
sed -i -e "s/^\#num_tokens: 256/num_tokens: $CASSANDRA_TOKEN/" $CASSANDRA_CONFIG/cassandra.yaml


if ! grep -q "auto_bootstrap: false" $CASSANDRA_CONFIG/cassandra.yaml; then
  sed -i '1s/^/auto_bootstrap: false\n/' $CASSANDRA_CONFIG/cassandra.yaml
fi

#echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.initial_token=$CASSANDRA_TOKEN\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

# Most likely not needed
#echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"" >> $CASSANDRA_CONFIG/cassandra-env.sh


cp -r /etc/cassandra/* /prueba/

echo "Starting Cassandra on $IP..."
