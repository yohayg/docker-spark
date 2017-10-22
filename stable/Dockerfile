FROM aa8y/core:jdk8

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

USER root

# Hadoop
# TODO: Move this to a different image this can use as a base.
RUN adduser -Ds /bin/bash hadoop
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
ARG HADOOP_VERSION=2.7.4
RUN mkdir -p $HADOOP_HOME && \
    apk add --no-cache --update wget && \
    wget -q -O- --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
      "http://apache.cs.utah.edu/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" | \
      tar -xz --strip 1 -C $HADOOP_HOME/ && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/* $HADOOP_HOME/share/doc && \
    chown -R hadoop:hadoop $HADOOP_HOME

# Spark
RUN adduser -Ds /bin/bash spark
ENV SPARK_HOME /opt/spark
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
ARG SPARK_VERSION=2.2.0
RUN mkdir -p $SPARK_HOME && \
    apk add --no-cache --update wget && \
    export SPARK_PACKAGE=spark-${SPARK_VERSION}-bin-hadoop$(echo $HADOOP_VERSION | sed 's/\.[0-9]$//g') && \
    wget -q -O- --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
      "https://d3kbcqa49mib13.cloudfront.net/${SPARK_PACKAGE}.tgz" | \
      tar -xz --strip 1 -C $SPARK_HOME/ && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/* && \
    chown -R spark:spark $SPARK_HOME

USER spark
WORKDIR $SPARK_HOME
CMD ["su", "-c", "bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
