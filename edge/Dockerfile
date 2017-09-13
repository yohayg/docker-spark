FROM openjdk:8-jdk-alpine

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

RUN apk add --no-cache --update bash && \
    rm -rf /var/cache/apk/*

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
ARG SCALA_VERSION=2.11
ARG SPARK_BRANCH=master
RUN mkdir -p $SPARK_HOME && \
    apk add --no-cache --update \
      ca-certificates \
      git \
      maven \
      wget && \
    git clone -b $SPARK_BRANCH https://github.com/apache/spark.git $SPARK_HOME && \
    cd $SPARK_HOME && \
    export AMPLAB_JENKINS=true && \
    ./dev/change-scala-version.sh $SCALA_VERSION && \
    ./build/mvn -DskipTests clean package && \
    apk del --purge \
      ca-certificates \
      git \
      maven \
      wget && \
    rm -rf /var/cache/apk/* $HOME/.m2 $HOME/.zinc && \
    chown -R spark:spark $SPARK_HOME

USER spark
WORKDIR $SPARK_HOME
CMD ["su", "-c", "bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
