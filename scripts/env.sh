#!/bin/sh

function warn {
	if ! eval "$@"; then
		echo >&2 "WARNING: command ($@) failed!"
		exit 1
	fi
}
