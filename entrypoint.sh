#!/bin/bash

# Default values
host=""
name=""

private_key_dir="/etc/ssh"

# Function to display script usage
usage() {
    echo "Usage: $0 -h|--host <host> -n|--name <name>"
    exit 1
}

# Parse command line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--host)
            if [ -n "$2" ]; then
                host="$2"
                shift 2
            else
                echo "Error: Missing host argument for option $1"
                usage
            fi
            ;;
        -n|--name)
            if [ -n "$2" ]; then
                name="$2"
                shift 2
            else
                echo "Error: Missing name argument for option $1"
                usage
            fi
            ;;
        *)
            echo "Error: Unknown option $1"
            usage
            ;;
    esac
done

# Check if both host and name are provided
if [ -z "$host" ] || [ -z "$name" ]; then
    echo "Error: Both host and name are mandatory"
    usage
fi


# Check if the directory exists
if [ ! -d "$private_key_dir" ]; then
  echo "Directory does not exist: $private_key_dir"
  exit 1
fi

for private_key_file in "${private_key_dir}"/ssh_host_*_key; do
  # Check if the private key is a file
  if [ -f "${private_key_file}" ]; then
    # Generate public key file name
    public_key_file="${private_key_file}.pub"

    # Generate public key and ignore existing ones
    ssh-keygen -y -f "${private_key_file}" > "${public_key_file}"
    echo "Generated public key: ${public_key_file}"
  fi
done

# Display the provided arguments
echo "Host: $host"
echo "Name: $name"


mkdir -p /kadalu/${name}

mount -t glusterfs ${host}:/${name} /kadalu/${name}
/usr/sbin/sshd -D -E /ssh.log
