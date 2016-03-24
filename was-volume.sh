#!/bin/bash

VOLUMEZONE=$1
VOLUMETYPE=$2
VOLUMESIZE=$3

volumeZone=${VOLUMEZONE:="cn-north-1b"}
volumeType=${VOLUMETYPE:="gp2"}
volumeSize=${VOLUMESIZE:=10}

echo $volumeZone

volumeId=$(aws ec2 create-volume --size $volumeSize --volume-type $volumeType --availability-zone $volumeZone | jq '.VolumeId')
if [ -z volumeId ]; then
  echo "aws ec2 volume create failed!!!"
  exit 3
fi

pvName="pv-$(openssl rand -hex 6)"
echo "
apiVersion: "v1"
kind: "PersistentVolume"
metadata:
  name: "${pvName}"
spec:
  capacity:
    storage: "${volumeSize}Gi"
  accessModes:
    - "ReadWriteOnce"
  awsElasticBlockStore:
    fsType: "ext4"
    volumeID: "${volumeId}"
" | oc create -f -
