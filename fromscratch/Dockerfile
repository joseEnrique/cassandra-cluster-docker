FROM ubuntu:16.04
RUN apt update

ENV CASSANDRA_CONFIG "/etc/cassandra/"



RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | \
           tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA && \
    apt-get update && \
    apt install cassandra -y &&  \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

COPY ./scripts/cassandra-clusternode.sh /



ENTRYPOINT ["./cassandra-clusternode.sh"]
