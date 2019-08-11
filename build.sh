#!/bin/bash

if ! [ -x "$(command -v getopt)" ]; then
  echo 'Error: getopt is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v sed)" ]; then
  echo 'Error: sed is not installed.' >&2
  exit 1
fi

# read the options
OPTS=$(getopt -o pa:mbk --long push,architectures:,manifest,background,keep --name "$0" -- "$@")
if [ $? != 0 ] ; then
	echo "Failed to parse options...exiting." >&2
	exit 1
fi
eval set -- "$OPTS"

# Defaults
PUSH=false
ARCHITECTURES=arm32v7,amd64
MANIFEST=false
BACKGROUND=false
KEEP=false

while true ; do
  case "$1" in
    -p | --push )
      PUSH=true
      shift
      ;;
    -a | --architectures )
      ARCHITECTURES="$2"
      shift 2
      ;;
    -m | --manifest )
      MANIFEST=true
      shift
      ;;
    -b | --background )
      BACKGROUND=true
      shift
      ;;
    -k | --keep )
      KEEP=true
      shift
      ;;
    -- )
      shift
      break
      ;;
    *)
      echo "Internal error!"
      exit 1
      ;;
  esac
done

if [ $# != 1 ]; then
	echo "No project folder specified!" >&2
	exit 1
fi

IFS=/
read -r s1 s2 <<< "$1"
REPOSITORY=$s1
PROJECT=$s2

if [ "$PROJECT" == '' ]; then
	echo "No repository given!" >&2
	exit 1
fi

if [ ! -f ./$PROJECT/Dockerfile ]; then
    echo "Project folder or dockerfile not found \"./$PROJECT/Dockerfile\"!" >&2
	exit 1
fi

if [ "$PUSH" == "false" ] && [ "$BACKGROUND" == "true" ]; then
	echo "INFO: Option -b or --background has no effect without -p oder --push." >&2
fi

cd ./$PROJECT
IFS=,
TAB=$'\t'
rm -f Dockerfile.*
for docker_arch in $ARCHITECTURES
do
	cp Dockerfile Dockerfile.${docker_arch}
  # prepend architecture only to official images (containing no '/')
  sed -i_ -E "s|^(FROM[${TAB} ]+)([^/]+)$|\1${docker_arch}/\2|g" Dockerfile.${docker_arch}
  # append architecture to my own images
  sed -i_ -E "s|^(FROM[${TAB} ]+${REPOSITORY}/[^:${TAB} ]+)(.*)|\1-${docker_arch}\2|g" Dockerfile.${docker_arch}
  docker build -f Dockerfile.${docker_arch} -t $REPOSITORY/$PROJECT-${docker_arch} .

  # push to repository
  if [ "$PUSH" == "true" ]; then
  	if [ "$BACKGROUND" == "true" ]; then
			# run push in background
			docker push $REPOSITORY/$PROJECT-${docker_arch} &
		else
			docker push $REPOSITORY/$PROJECT-${docker_arch}
		fi
	fi

	if [ "$KEEP" == "false" ]; then
		rm Dockerfile.${docker_arch}
		rm Dockerfile.${docker_arch}_
	fi
	arch_images="${arch_images} $REPOSITORY/$PROJECT-${docker_arch}"
done

wait
if [ "$MANIFEST" == "true" ]; then
	rm -R ~/.docker/manifests/docker.io_${REPOSITORY}_${PROJECT}-latest
	docker manifest create "${REPOSITORY}/${PROJECT}:latest" $arch_images
	if [ "$PUSH" == "true" ]; then
		docker manifest push ${REPOSITORY}/${PROJECT}:latest
	fi
fi
