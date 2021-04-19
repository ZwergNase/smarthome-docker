#!/bin/bash
TAB=$'\t'
EOL=$'\n'

if ! [ -x "$(command -v getopt)" ]; then
  echo 'Error: getopt is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v sed)" ]; then
  echo 'Error: sed is not installed.' >&2
  exit 1
fi

function execute {
	if [ $VERBOUSE = 'true' ] || [ $SUPERVERBOUSE = 'true' ]; then
		[ "$2" != '' ] && printf "${2}:\n"
		[ "$1" != '' ] && printf " > ${1}\n"
	fi

	if [ "$1" != '' ]; then
		if [ $SUPERVERBOUSE = 'true' ]; then
			exec 5>&1
			EXECUTE_STDOUT=$(eval $1 2>&1 | tee /dev/fd/5)
			exec &>$(tty)
		else
			 EXECUTE_STDOUT=$(eval $1 2>&1)
		fi
	fi
}

# read the options
OPTS=$(getopt -o pa:klmfnv --long push,architectures:,keep,latest,manifest,forcelatest,no-cache,verbouse,superverbouse --name "$0" -- "$@")
if [ $? != 0 ] ; then
	echo "Failed to parse options...exiting." >&2
	exit 1
fi
eval set -- "$OPTS"

# Defaults
PUSH=false
ARCHITECTURES=arm32v7,amd64
MANIFEST=false
KEEP=false
LATEST=false
MANIFEST=false
FORCELATEST=false
NOCACHE=false
VERBOUSE=false
SUPERVERBOUSE=false

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
    -k | --keep )
      KEEP=true
      shift
      ;;
    -l | --latest )
      LATEST=true
      shift
      ;;
    -m | --manifest )
      MANIFEST=true
      shift
      ;;
    -f | --forelatest )
      FORCELATEST=true
      shift
      ;;
    -n | --no-cache )
      NOCACHE=true
      shift
      ;;
    -v | --verbouse )
	if [ $VERBOUSE == 'true' ]; then
		SUPERVERBOUSE=true
	else
	      VERBOUSE=true
	fi
      shift
      ;;
    --superverbouse )
      SUPERVERBOUSE=true
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

if [ "$MANIFEST" == "true" ] && [ "$PUSH" == "false" ]; then
	echo "Currently --manifest|-m is only supported with --push|-p" >&2
	exit 1
fi

[ "$NOCACHE" == "true" ] && CACHEOPTION='--no-cache'

IFS=:
read -r PROJECT VERSION <<< "$temp"

DOCKERFILE=Dockerfile
[ "$VERSION" != '' ] && DOCKERFILE="${DOCKERFILE}-${VERSION}"

if [ ! -f "./${PROJECT}/${DOCKERFILE}" ]; then
	echo "Project folder or dockerfile not found \"./${PROJECT}/${DOCKERFILE}\"!" >&2
	exit 1
fi

IFS=,
declare -A ARCH_IMAGES
declare -A ARCH_IMAGES_LATEST
for docker_arch in ${ARCHITECTURES}
do
	execute '' ":::::::::::::::::::::::::::::\n ${docker_arch}\n::::::::::::::::::::::::::::"
	# prepend architecture only to official images (containing no '/')
	sed -E "s|^(FROM[${TAB} ]+)([^/]+)$|\1${docker_arch}/\2|g" ${PROJECT}/${DOCKERFILE} |
	# append architecture to my own images
	sed -E "s|^(FROM[${TAB} ]+${REPOSITORY}/[^:${TAB} ]+)(.*)|\1-${docker_arch}\2|g" > ${PROJECT}/${DOCKERFILE}-${docker_arch}

	[ "$FORCELATEST" == "true" ] && execute "sed -n 's/FROM[ \t]\+\(.*:latest\)[ \t]*.*/docker pull \1/pe' ${PROJECT}/${DOCKERFILE}-${docker_arch}" 'pull latest version of images'

	execute "docker build -f \"${PROJECT}/${DOCKERFILE}-${docker_arch}\" ${CACHEOPTION} ${PROJECT}" 'build all images in dockerfile'

	TEMP=${EXECUTE_STDOUT}
	FIND_LABELS=${TEMP//[$'\n\r']}
	FIND_LABELS=${FIND_LABELS//LABEL/${EOL}LABEL}
	mapfile -t < <(echo ${FIND_LABELS} | sed -n "s/^LABEL[ \t]*image=\([^ \t]*\) --->[^-]*---> \([0-9a-f]*\).*/\2,\1/p")
	unset IMAGES
	declare -A IMAGES
	for var in "${MAPFILE[@]}"
	do
		IFS=, read HASH NAME <<< ${var}
		IMAGES["$HASH"]=${NAME}
	done
	if [ ${#IMAGES[@]} -eq 0 ]; then
		HASH=$(echo ${TEMP} | sed -n 's/Successfully built \([0-9a-f]*\)/\1/p')
		IMAGES["$HASH"]=${PROJECT}
	fi

        [ "$PUSH" == "true" ] && execute "docker login" 'log into repository'

	execute '' 'tag all images'
	for HASH in "${!IMAGES[@]}"
	do
	        NAME=${IMAGES[$HASH]}
		if [ "$VERSION" != '' ]; then
        	        execute "docker tag ${HASH} ${REPOSITORY}/${NAME}-${docker_arch}:${VERSION}"
			ARCH_IMAGES["$NAME"]+=" ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}:${VERSION}"
			[ "$PUSH" == "true" ] && execute "docker push ${REPOSITORY}/${NAME}-${docker_arch}:${VERSION}"
        	else
                	execute "docker tag ${HASH} ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}"
			ARCH_IMAGES["$NAME"]+=" ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}"
        		[ "$PUSH" == "true" ] && execute "docker push ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}"
		fi
        	if [ "$LATEST" == "true" ]; then
                	execute "docker tag ${HASH} ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}:latest"
			ARCH_IMAGES_LATEST["$NAME"]+=" ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}:latest"
			[ "$PUSH" == "true" ] && execute "docker push ${REPOSITORY}/${IMAGES[$HASH]}-${docker_arch}:latest"
        	fi
	done

	FIND_SUPERFLUOUS=${TEMP//[$'\n\r']}
	FIND_SUPERFLUOUS=${FIND_SUPERFLUOUS//--->/${EOL}--->}
	TEMP=$(echo ${FIND_SUPERFLUOUS} | sed -n 's/^---> \([0-9a-f]*\)Step [0-9]*\/[0-9]* : FROM.*/docker image rm \1/p')
 	[ "$TEMP" != '' ] && execute $TEMP 'deleting superfluous images'

	[ "$KEEP" == "false" ] && rm ${PROJECT}/${DOCKERFILE}-${docker_arch}

done

if [ "$MANIFEST" == "true" ]; then
	execute '' ":::::::::::::::::::::::::::::\n manifests\n::::::::::::::::::::::::::::"
	for PROJECT in "${!ARCH_IMAGES[@]}"
	do
		LIST=${ARCH_IMAGES[$PROJECT]}
		if [ "$VERSION" != '' ]; then
	                execute "docker manifest rm ${REPOSITORY}/${PROJECT}:${VERSION}" 'delete old manifest'
	                execute "docker manifest create ${REPOSITORY}/${PROJECT}:${VERSION} ${LIST}" 'create manifest'
	       	        execute "docker manifest push ${REPOSITORY}/${PROJECT}:${VERSION}" 'push manifest to repository'
        	       	execute "docker pull ${REPOSITORY}/${PROJECT}:${VERSION}" 'pull manifest to local repositroy'
		else
			execute "docker manifest rm ${REPOSITORY}/${PROJECT}" 'delete old manifest'
        	        execute "docker manifest create ${REPOSITORY}/${PROJECT} ${LIST}" 'create manifest'
                	execute "docker manifest push ${REPOSITORY}/${PROJECT}" 'push manifest to repository'
                	execute "docker pull ${REPOSITORY}/${PROJECT}" 'pull manifest to local repositroy'
		fi
	done
	if [ "$LATEST" == "true" ]; then
        	for PROJECT in "${!ARCH_IMAGES_LATEST[@]}"
        	do
			LIST=${ARCH_IMAGES_LATEST[$PROJECT]}
			execute "docker manifest rm ${REPOSITORY}/${PROJECT}:latest" 'delete old manifest'
                	execute "docker manifest create ${REPOSITORY}/${PROJECT}:latest ${LIST}" 'create manifest'
	                execute "docker manifest push ${REPOSITORY}/${PROJECT}:latest" 'push manifest to repository'
        	        execute "docker pull ${REPOSITORY}/${PROJECT}:latest" 'pull manifest to local repositroy'
		done
	fi
fi
