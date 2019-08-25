#!/bin/bash
cd /home/container
sleep 1
# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`


## if auto_update is no set or to 1 update
if [  -z ${AUTO_UPDATE} ] || [ ${AUTO_UPDATE} == 1 ]; then 
    # Update Server
    cd /home/container
    curl "http://www.byond.com/download/build/${BYOND_MAJOR_CUST}/${BYOND_MAJOR_CUST}.${BYOND_MINOR_CUST}_byond_linux.zip" -o byond.zip
    unzip byond.zip
    cd byond
    make here
    cd ../
    rm -rf byond.zip
    cd byondServer/${ServerBaseDir}
    git pull
    DreamMaker *.dme
else
    echo -e "not updating game server as auto update was set to 0"
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
