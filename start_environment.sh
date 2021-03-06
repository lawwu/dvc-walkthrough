#!/bin/bash

REPO_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOUNT_FOLDER=$REPO_FOLDER/mount_folder
mkdir -p $MOUNT_FOLDER

docker stop dvc-walkthrough
docker rm dvc-walkthrough
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t dvc-walkthrough .
docker run -d --mount type=bind,source=$MOUNT_FOLDER,target=/remote --name dvc-walkthrough dvc-walkthrough

if [[ "$*" =~ "walkthrough" ]]; then
  rm -rf $MOUNT_FOLDER/*
  docker exec --user dvc -ti dvc-walkthrough bash -c "cd /home/dvc/walkthrough; bash ../scripts/walkthrough.sh"
fi

if [[ "$*" =~ "clone" ]]; then
  docker exec --user dvc -ti dvc-walkthrough bash /home/dvc/scripts/clone.sh
fi

if [[ "$*" =~ "bash" ]]; then
  docker exec --user dvc -ti dvc-walkthrough bash -c "cd /home/dvc/walkthrough; bash"
fi
