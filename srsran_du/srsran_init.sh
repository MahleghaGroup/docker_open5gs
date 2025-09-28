#!/bin/bash

# BSD 2-Clause License

# Copyright (c) 2020, Supreeth Herle
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)

mkdir -p /etc/srsran

if [[ -z "$COMPONENT_NAME" ]]; then
	echo "Error: COMPONENT_NAME environment variable not set"; exit 1;
elif [[ "$COMPONENT_NAME" =~ ^(du[[:digit:]]*$) ]]; then
	echo "Configuring component: '$COMPONENT_NAME'"
	cp /mnt/srsran/${COMPONENT_NAME}.yml /etc/srsran/du.yml
  elif [[ "$COMPONENT_NAME" =~ ^(du_zmq[[:digit:]]*$) ]]; then
	echo "Configuring component: '$COMPONENT_NAME'"
	cp /mnt/srsran/${COMPONENT_NAME}.yml /etc/srsran/du.yml
else
	echo "Error: Invalid component name: '$COMPONENT_NAME'"
fi

cp /mnt/srsran/qos.yml /etc/srsran/qos.yml

sed -i 's|PLMN|'$MCC''$MNC'|g' /etc/srsran/du.yml
sed -i 's|AMF_IP|'$AMF_IP'|g' /etc/srsran/du.yml
sed -i 's|SRS_GNB_DU_F1_IP|'$SRS_GNB_DU_F1_IP'|g' /etc/srsran/du.yml
sed -i 's|SRS_GNB_DU_F1_IP|'$SRS_GNB_DU_F1_IP'|g' /etc/srsran/du.yml
sed -i 's|SRS_GNB_CU_F1_IP|'$SRS_GNB_CU_F1_IP'|g' /etc/srsran/du.yml
sed -i 's|SRS_GNB_DU_UE_IP|'$SRS_GNB_DU_UE_IP'|g' /etc/srsran/du.yml
sed -i 's|SRS_UE_IP|'$SRS_UE_IP'|g' /etc/srsran/du.yml
sed -i 's|DOCKER_HOST_IP|'$DOCKER_HOST_IP'|g' /etc/srsran/du.yml
sed -i 's|NEAR_RT_RIC_E2_IP|'$NEAR_RT_RIC_E2_IP'|g' /etc/srsran/du.yml
sed -i 's|SRS_GNB_DU_E2_IP|'$SRS_GNB_DU_E2_IP'|g' /etc/srsran/du.yml


# For dbus not started issue when host machine is running Ubuntu 22.04
service dbus start && service avahi-daemon start

echo Salam
echo $SRS_GNB_DU_IP

#sleep infinity

exec srsdu -c /etc/srsran/du.yml $@

# exec srsdu -c /etc/srsran/du.yml -c /etc/srsran/qos.yml $@

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
