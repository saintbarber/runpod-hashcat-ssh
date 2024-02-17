#!/bin/bash

# Make sure you have setup SSH keys within runpod for the below to work
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh/authorized_keys
service ssh start
sleep infinity