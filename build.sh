#!/bin/bash

PUSH=$1

# Spark Versions
SPARK_VERSIONS=(1.6.0 1.6.1 1.6.2 1.6.3 2.0.0 2.0.1 2.0.2 2.1.0 2.1.1 2.2.0)
# Non-version tags
TAGS=(latest)

# Images with all datasets and hence non-dataset-specific tags.
for TAG in "${TAGS[@]}"; do
  docker build -t aa8y/spark:"$TAG" .
done
# Build images for tags named by version.
for SPARK_VERSION in "${SPARK_VERSIONS[@]}"; do
  if [[ "$SPARK_VERSION" > "2.0.0" ]] || [[ "$SPARK_VERSION" == "2.0.0" ]]; then
    HADOOP_VERSION=2.7.3
  else
    HADOOP_VERSION=2.6.5
  fi
  TAG="$SPARK_VERSION"
  TAGS+=($TAG)
  echo Building Spark $SPARK_VERSION with Hadoop $HADOOP_VERSION
  docker build -t aa8y/spark:"$TAG" \
    --build-arg HADOOP_VERSION="$HADOOP_VERSION" \
    --build-arg SPARK_VERSION="$SPARK_VERSION" .
done

# If the push flag is set, push all tags.
if [ "$PUSH" == "-p" ]; then
  for TAG in "${TAGS[@]}"; do
    docker push aa8y/spark:"$TAG"
  done
fi
