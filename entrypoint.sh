#!/bin/bash

# Default values
host=""
name=""

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

# Display the provided arguments
echo "Host: $host"
echo "Name: $name"

mount -t glusterfs ${host}:/${name} /mnt
/usr/sbin/sshd -D
