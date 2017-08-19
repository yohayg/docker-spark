FROM openjdk:8-jdk-alpine

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

RUN apk add --no-cache --update \
      bash \
      ca-certificates \
      wget && \
    rm -rf /var/cache/apk/*

# Hadoop
# TODO: Move this to a different image this can use as a base.
RUN adduser -Ds /bin/bash hadoop
ARG HADOOP_VERSION=2.7.3
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
RUN mkdir -p $HADOOP_HOME && \
    wget -q -O- --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
      "http://apache.cs.utah.edu/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" | \
      tar -xz --strip 1 -C $HADOOP_HOME/ && \
    rm -rf $HADOOP_HOME/share/doc && \
    chown -R hadoop:hadoop $HADOOP_HOME

# Spark
RUN adduser -Ds /bin/bash spark
ARG SPARK_VERSION=2.2.0
ENV SPARK_HOME /opt/spark
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN mkdir -p $SPARK_HOME && \
    export SPARK_PACKAGE=spark-${SPARK_VERSION}-bin-hadoop$(echo $HADOOP_VERSION | sed 's/\.[0-9]$//g') && \
    wget -q -O- --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
      "https://d3kbcqa49mib13.cloudfront.net/${SPARK_PACKAGE}.tgz" | \
      tar -xz --strip 1 -C $SPARK_HOME/ && \
    chown -R spark:spark $SPARK_HOME

USER root
WORKDIR $SPARK_HOME
CMD ["su", "-c", "bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
