#!/bin/bash
WGET="/usr/bin/wget"
WGET1="wget https://github.com/dynatrace/dynatrace-operator/releases/latest/download/install.sh"
API_URL="https://xsj12315.live.dynatrachtte.com/api"
API_TOKEN=
PAAS_TOKEN=
CLUSTER_NAME="eks_cluster"
INSTALL_FILE= "install.sh"
#Downloading official Dynatrace operator script 

if [ -x "$WGET" ]; then
    if  ${WGET1} -O ${INSTALL_FILE}; then
      # Success
        echo "Initiating File Download"
     else
        echo "Failed to download file!!" >&2
        exit 1
    fi
else
    echo "No wget under ${WGET}" >&2
    exit 2
fi

#Checking for script and execution of script

if [[ -f "$INSTALL_FILE" ]]; then
    
    echo "Download of script is successfull".
    echo "Initiating script execution"
    sh ./install.sh --api-url $API_URL --api-token "" --paas-token "" --cluster-name "demo"
    ##sh ./${INSTALL_FILE}
    ##    -api-url  ${API_URL} 
    ##    --api-token $(eval echo ${API_TOKEN} | base64 --decode)
    ##    --paas-token $(eval echo ${PASS_TOKEN} | base64 --decode)
    ##    --cluster-name ${CLUSTER_NAME}
else 
    echo "Script has failed to run/execute" >&2
    exit 3
fi
