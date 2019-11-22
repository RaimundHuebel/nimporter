#!/bin/sh

###
# Docker-Entrypoint for Debian based Linux-Container (like Ubuntu).
#
# @author Raimund Hübel <raimund.huebel@googlemail.com>
###


main() {
    case "$1" in
    "")         help ;;
    "help")     help ;;
    "console")  console ;;
    "cli")      console ;;
    "infinite") infinite ;;
    *)          exec "$@" ;;
    esac
}


help() {
    echo "USAGE:   $0 [infinite | console | cli | help | <shell-command ...>]"
    echo "DEFAULT: $0 [run]"
    echo "EXAMPLE: $0"
    echo "EXAMPLE: $0 help"
    echo "EXAMPLE: $0 console"
    echo "EXAMPLE: $0 cli"
    echo "EXAMPLE: $0 infinite"
    echo "EXAMPLE: $0 /bin/bash"
    echo "EXAMPLE: $0 nim -v"
}

infinite() {
  log_info "running infinite on '$(hostname)' ..."
  /bin/sleep infinity
}

console() {
  log_info "starting console on '$(hostname)' ..."
  exec /bin/bash -i
}

abort() {
  local message="$1"
  echo "[ABORT] $message"
  exit 1
}

log_info() {
  local message="$1"
  echo "[INFO] $message"
}

log_warn() {
  local message="$1"
  echo "[WARN] $message"
}

SCRIPT_DIR=$(dirname $(realpath "$0"))
#log_info "changing to directory: $SCRIPT_DIR"
#cd "$SCRIPT_DIR" || abort "failed to change directory"
main "$@"
exit 0
