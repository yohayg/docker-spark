# Docker Spark

[Apache Spark](http://spark.apache.org) is a framework for doing distributed Big Data processing. This project contains files to build a Docker image for Spark. It is a fork of [semantive/spark](https://github.com/Semantive/docker-spark) but has been modified to use Alpine as base to make the final image smaller. It can be used in a standalone cluster or with the accompanying `docker-compose.yml` as a base for more complex recipes.

## Simple example

To run `SparkPi`, run the image with Docker:

```
docker run --rm -it -p 4040:4040 aa8y/spark bin/run-example SparkPi 10
```

## Cluster example [docker-compose]

To create a simple standalone cluster with [docker-compose](http://docs.docker.com/compose) use:

```
docker-compose up
```

The SparkUI will be running at `http://${YOUR_DOCKER_HOST}:8080` with one worker listed and Spark jobs may be submitted using master `spark://${YOUR_DOCKER_HOST}:7077`. To connect via spark-shell with cluster use:

```
spark-shell --master spark://localhost:7077
```

## License

Apache Licence
