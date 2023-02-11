#! /bin/bash

# This script is used to push the changes to the remote repository

# Path: jenkins\configs\scripts\push.sh

echo "Pushing changes to remote repository ..."

local_image_name=whanos-$2

if [ "$1" = "true" ]; then
    echo "Pushing to docker hub"
    if ! docker tag $local_image_name $6:$7; then
        echo "Docker tag failed"
        exit 1
    fi


    if ! docker login $3 -u "$4" -p "$5"; then
        echo "Docker login failed"
        exit 1
    fi

    if ! docker push $6:$7; then
        echo "Docker push failed"
        exit 1
    fi
fi