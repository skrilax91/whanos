#! /bin/bash

LANGUAGE=()

## Test if the project is a C project
if [[ -f Makefile ]]; then
	LANGUAGE+=("c")
fi

## Test if the project is a Java project
if [[ -f app/pom.xml ]]; then
	LANGUAGE+=("java")
fi

## Test if the project is a NodeJS project
if [[ -f package.json ]]; then
	LANGUAGE+=("javascript")
fi

## Test if the project is a Python project
if [[ -f requirements.txt ]]; then
	LANGUAGE+=("python")
fi

## Test if the project is a Befunge project
if [[ $(find app -type f) == app/main.bf ]]; then
	LANGUAGE+=("befunge")
fi

## Check if the project is valid (one language only)
if [[ ${#LANGUAGE[@]} == 0 ]]; then
	echo "Invalid project: no language matched."
	exit 1
fi
if [[ ${#LANGUAGE[@]} != 1 ]]; then
	echo "Invalid project: multiple language matched (${LANGUAGE[@]})."
	exit 1
fi
echo ${LANGUAGE[@]} matched

image_name=$DOCKER_REGISTRY/whanos/whanos-$1-${LANGUAGE[0]}

if [[ -f Dockerfile ]]; then
	docker build . -t $image_name
else
	docker build . \
		-f /images/${LANGUAGE[0]}/Dockerfile.standalone \
		-t $image_name
fi

if ! docker push $image_name; then
	exit 1
fi