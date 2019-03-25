#!/bin/bash

cd $1
for docker_arch in arm32v7 amd64 
do
	cp Dockerfile Dockerfile.${docker_arch}
	sed -i '' -E "s|FROM(.+)debian:|FROM\1${docker_arch}/debian:|g" Dockerfile.${docker_arch}
	sed -i '' -E "s|FROM(.*)oliverf/([^ \t]+)|FROM\1oliverf/\2:$docker_arch|g" Dockerfile.${docker_arch}
	docker build -f Dockerfile.${docker_arch} -t oliverf/$1:${docker_arch} .
	docker push oliverf/$1:${docker_arch} &
	rm Dockerfile.${docker_arch}
	arch_images="${arch_images} oliverf/$1:${docker_arch}"
done
wait
rm -R ~/.docker/manifests/docker.io_oliverf_$1-latest
docker manifest create oliverf/$1:latest $arch_images
docker manifest push oliverf/$1:latest
