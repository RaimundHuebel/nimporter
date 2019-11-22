#!/bin/sh

###
# Entry-Script to support the development using a docker environment.
# Setups the needed Docker-Images and Container for itself, providing the user an easy userexperience.
#
# @example Usage
# ```sh
#  $ ./nimporter-dev.sh [console | cli | help | <shell-command ...> | infinite]"
#  $ ./nimporter-dev.sh"
#  $ ./nimporter-dev.sh help"
#  $ ./nimporter-dev.sh console"
#  $ ./nimporter-dev.sh cli"
#  $ ./nimporter-dev.sh infinite"
#  $ ./nimporter-dev.sh /bin/bash"
#  $ ./nimporter-dev.sh nim -v"
# ```
#
# @author Raimund Hübel <raimund.huebel@googlemail.com>
###

SCRIPT_DIR=$(dirname $(realpath "$0"))
NIMPORTER_DEV_DIR="$SCRIPT_DIR/.nimporter-dev"

echo "[INFO] Starting nimporter/dev-system ..."
cd "$SCRIPT_DIR" || (echo "failed to change directory"; exit 1)


echo "[INFO] Check if nimporter/dev-system:1.0 is available ..."
COUNT_BUILD_SYSTEM_IMAGES=$(docker images nimporter/dev-system:1.0 | wc -l)
if [ "2" -ne "$COUNT_BUILD_SYSTEM_IMAGES" ]; then
  echo "[INFO] nimporter/dev-system:1.0 not locally available -> build it!"
  docker build \
    --force-rm=true \
    --tag="nimporter/dev-system:1.0" \
    --file="$NIMPORTER_DEV_DIR/Dockerfile" \
    "$NIMPORTER_DEV_DIR/" \
    || (echo "[ERROR] Failed to build nimporter/dev-system:1.0"; exit 0)
  echo "[OK  ] nimporter/dev-system:1.0 was builded successfully"
else
  echo "[OK  ] nimporter/dev-system:1.0 seems to be locally available -> use it!"
fi


echo "[INFO] Running docker container 'nimporter-dev-system-v1-run' using image 'nimporter/dev-system:1.0'"
COUNT_BUILD_SYSTEM_CONTAINER=$(docker ps -a | grep nimporter-dev-system-v1-run | wc -l)
if [ ! "0" -eq "$COUNT_BUILD_SYSTEM_CONTAINER" ]; then
  echo "[INFO] Delete previous nimporter-dev-system-v1-run container ..."
  docker rm nimporter-dev-system-v1-run
fi

echo "[EXEC] execute in docker: $@"
exec docker run \
       --name 'nimporter-dev-system-v1-run' \
       -it --rm \
       --mount type=tmpfs,destination=/tmp \
       --mount type=tmpfs,destination=/home/dev/.cache \
       --mount type=tmpfs,destination=/home/dev/.nimble \
       -w '/home/dev/nimporter' \
       --volume "$SCRIPT_DIR":"/home/dev/nimporter" \
       'nimporter/dev-system:1.0' "$@"

exit 0
