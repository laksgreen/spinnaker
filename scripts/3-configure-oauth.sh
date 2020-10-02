#!/bin/bash

# Pass the variable that need to be set:

INSTANCE_IP=`curl -s ifconfig.co`
read -p "Enter Client Id: " CLIENT_ID
read -p "Enter Client Secret: " CLIENT_SECRET
read -p "Provider {gitlab|google|github|azure}: " PROVIDER

REDIRECT_URI=http://$INSTANCE_IP:8084/login

set -e

if [ -z "${CLIENT_ID}" ] ; then
  echo "CLIENT_ID not set"
  exit
fi
if [ -z "${CLIENT_SECRET}" ] ; then
  echo "CLIENT_SECRET not set"
  exit
fi
if [ -z "${PROVIDER}" ] ; then
  echo "PROVIDER not set"
  exit
fi
if [ -z "${REDIRECT_URI}" ] ; then
  echo "REDIRECT_URI not set"
  exit
fi

hal config security authn oauth2 edit \
  --client-id $CLIENT_ID \
  --client-secret $CLIENT_SECRET \
  --provider $PROVIDER
hal config security authn oauth2 enable

hal config security authn oauth2 edit --pre-established-redirect-uri $REDIRECT_URI

hal config security ui edit \
    --override-base-url http://${INSTANCE_IP}:9000

hal config security api edit \
    --override-base-url http://${INSTANCE_IP}:8084
