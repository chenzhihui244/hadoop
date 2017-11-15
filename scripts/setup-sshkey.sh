#!/bin/bash

function setup_local_ssh_auth {
	ssh-keygen -t rsa
	ssh-copy-id root@localhost
}

setup_local_ssh_auth
