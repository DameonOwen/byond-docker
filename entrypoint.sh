#!/bin/bash
cd /home/container
sleep 1
# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`


## if auto_update is no set or to 1 update
if [  -z ${AUTO_UPDATE} ] || [ ${AUTO_UPDATE} == 1 ]; then 
    # Update Server
    cd /home/container
    curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip
    unzip byond.zip
    cd byond
    sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile
    make install
    cd ../
    rm -rf byond byond.zip
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
