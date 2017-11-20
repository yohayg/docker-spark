### Spark edge tarball builder.
FROM aa8y/core:jdk8 as builder

ENV AMPLAB_JENKINS true
ARG SCALA_VERSION=2.11
ARG SPARK_BRANCH=master

USER root
WORKDIR /tmp
RUN apk add --no-cache --update \
      ca-certificates \
      git \
      maven \
      py-setuptools \
      python \
      wget \
 && rm -rf /var/cache/apk/*
RUN git clone -b $SPARK_BRANCH https://github.com/apache/spark.git \
 && cd spark \
 && ./dev/change-scala-version.sh $SCALA_VERSION \
 && if [ SPARK_BRANCH == barnch-1.6 ]; then \
      export DISTRIBUTOR=./make-distribution.sh; \
    else \
      export DISTRIBUTOR=./dev/make-distribution.sh; \
    fi \
 && $DISTRIBUTOR \
      --name edge \
      --pip \
      --tgz \
      -Phadoop-2.7 \
      -Phive \
      -Phive-thriftserver \
      -Pmesos \
      -Pyarn

### Spark edge tarball consumer.
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
ARG SPARK_VERSION=2.3.0

RUN mkdir -p $SPARK_HOME
COPY --from=builder /tmp/spark/spark-$SPARK_VERSION-SNAPSHOT-bin-edge.tgz ./spark-edge.tgz
RUN tar -xzf spark-edge.tgz --strip 1 -C $SPARK_HOME/ && \
    chown -R spark:spark $SPARK_HOME

WORKDIR $SPARK_HOME
USER spark
CMD ["su", "-c", "bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
