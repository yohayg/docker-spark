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

## Tags

We have tags for each Spark version starting `1.6.0` to `2.2.0`. The tags `1` and `1.6` point to the `1.6.3` which is the latest release for that major/minor version. Similarly `2` and `2.2` point to `2.2.0`. `latest` always points to latest Spark release which in this case is `2.2.0`.

Newer Edge tags have been added. These tags build Spark from the source and hence have the most recent code for the minor version. This is especially useful when you want to test the newer Spark code which has not been released. These images are very bloated and untested. This would be fixed in subsequent releases. We have tags starting from `edge-1.6` to `edge-2.2` for each minor Spark release and correspond to their respective branches on Github. `edge` points to the `master` branch.

You can always refer to the `manifest.yml` file for more information about the images being built (see below).

### Building / Pushing / Tagging docker images

The project uses [Docker Helper](https://github.com/aa8y/docker-helper) which I wrote to manage docker images since I felt that the automated build system is inadequalte. It has been added as a `git submodule`. So if you fork the repository and want to build your own images, change the `manifest.yml` file, run `git submodule init`, `git submodule update` and use the build script.

## License

Apache Licence
