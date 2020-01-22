#!/bin/bash
TAB=$'\t'

if ! [ -x "$(command -v getopt)" ]; then
  echo 'Error: getopt is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v sed)" ]; then
  echo 'Error: sed is not installed.' >&2
  exit 1
fi

# read the options
OPTS=$(getopt -o pa:bk --long push,architectures:,background,keep --name "$0" -- "$@")
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
	echo "No project specified!" >&2
	exit 1
fi

IFS=/
read -r REPOSITORY temp <<< "$1"

if [ "$temp" == '' ]; then
        echo "No repository given!" >&2
        exit 1
fi

IFS=:
read -r PROJECT VERSION <<< "$temp"

DOCKERFILE=Dockerfile
if [ "$VERSION" != '' ]; then
	DOCKERFILE="${DOCKERFILE}-${VERSION}"
fi

if [ ! -f "./${PROJECT}/${DOCKERFILE}" ]; then
	echo "Project folder or dockerfile not found \"./${PROJECT}/${DOCKERFILE}\"!" >&2
	exit 1
fi

if [ "$PUSH" == "false" ] && [ "$BACKGROUND" == "true" ]; then
	echo "INFO: Option -b or --background has no effect without -p oder --push." >&2
fi

IFS=,

ARCH_IMAGES=()
for docker_arch in ${ARCHITECTURES}
do
	# prepend architecture only to official images (containing no '/')
	sed -E "s|^(FROM[${TAB} ]+)([^/]+)$|\1${docker_arch}/\2|g" ${PROJECT}/${DOCKERFILE} |
	# append architecture to my own images
	sed -E "s|^(FROM[${TAB} ]+${REPOSITORY}/[^:${TAB} ]+)(.*)|\1-${docker_arch}\2|g" > ${PROJECT}/${DOCKERFILE}-${docker_arch}

	IMAGE=${REPOSITORY}/${PROJECT}-${docker_arch}
	if [ "$VERSION" != '' ]; then
		IMAGE=${IMAGE}:${VERSION}
	fi

	docker build -f "${PROJECT}/${DOCKERFILE}-${docker_arch}" -t ${IMAGE} ${PROJECT}

	# push to repository
	if [ "$PUSH" == "true" ]; then
		if [ "$BACKGROUND" == "true" ]; then
			# run push in background
				docker push $IMAGE &
			else
				docker push $IMAGE
		fi
	fi

	if [ "$KEEP" == "false" ]; then
		rm ${PROJECT}/${DOCKERFILE}-${docker_arch}
	fi

	ARCH_IMAGES+=($IMAGE)
done
