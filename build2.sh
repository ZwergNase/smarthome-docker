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
ARCHITECTURES=arm32v7,amd64
KEEP=false

while true ; do
  case "$1" in
    -a | --architectures )
      ARCHITECTURES="$2"
      shift 2
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

if [ ! -f ./$PROJECT/Dockerfile ]; then
    echo "Project folder or dockerfile not found \"./$PROJECT/Dockerfile\"!" >&2
	exit 1
fi

cd ./$PROJECT
IFS=,
TAB=$'\t'
rm -f Dockerfile.*
for docker_arch in $ARCHITECTURES
do
	cp Dockerfile Dockerfile.${docker_arch}
	sed -i -E "s|FROM([${TAB} ]+)debian:|FROM\1${docker_arch}/debian:|g" Dockerfile.${docker_arch}
	sed -i -E "s|FROM([${TAB} ]+)$REPOSITORY([^${TAB}: ]+) |FROM\1$REPOSITORY\2:$docker_arch |g" Dockerfile.${docker_arch}
	
	exec 42>&1
	OUTPUT=$(docker build -f Dockerfile.${docker_arch} -t $REPOSITORY$PROJECT:${docker_arch} . | tee /dev/fd/42)
	
	if [ "$KEEP" == "false" ]; then
		rm Dockerfile.${docker_arch}
	fi
	arch_images="${arch_images} $REPOSITORY$PROJECT:${docker_arch}"

done
