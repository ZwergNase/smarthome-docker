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
MANIFEST=true
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
if [ -z "$s2" ]; then
	REPOSITORY=''
	PROJECT=$s1
else
	REPOSITORY=$s1/
	PROJECT=$s2
fi

if [ "$PUSH" == "true" ] && [ "$REPOSITORY" == '' ]; then
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
	sed -i '' -E "s|FROM([${TAB} ]+)debian:|FROM\1${docker_arch}/debian:|g" Dockerfile.${docker_arch}
  sed -i '' -E "s|FROM([${TAB} ]+)$REPOSITORY([^${TAB}: ]+) |FROM\1$REPOSITORY\2:$docker_arch |g" Dockerfile.${docker_arch}
  docker build -f Dockerfile.${docker_arch} -t $REPOSITORY$PROJECT:${docker_arch} .

  # push to repository
  if [ "$PUSH" == "true" ]; then
  	if [ "$BACKGROUND" == "true" ]; then
			# run push in background
			docker push $REPOSITORY$PROJECT:${docker_arch} &
		else
			docker push $REPOSITORY$PROJECT:${docker_arch}
		fi
	fi

	if [ "$KEEP" == "false" ]; then
		rm Dockerfile.${docker_arch}
	fi
	arch_images="${arch_images} $REPOSITORY$PROJECT:${docker_arch}"
done

wait
if [ "$MANIFEST" == "true" ]; then
  # replace slash between repository and project with underscore
  REPOSITORY=${REPOSITORY/\//_}
	rm -R ~/.docker/manifests/docker.io_${REPOSITORY}$PROJECT-latest
  # and change back
  REPOSITORY=${REPOSITORY/_/\/}
	docker manifest create $REPOSITORY$PROJECT:latest $arch_images
	if [ "$PUSH" == "true" ]; then
  echo nix
		docker manifest push $REPOSITORY$PROJECT:latest
	fi
fi
