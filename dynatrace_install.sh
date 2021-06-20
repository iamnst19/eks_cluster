#!/bin/bash
WGET="/usr/bin/wget"
WGET1="wget https://github.com/dynatrace/dynatrace-operator/releases/latest/download/install.sh"
API_URL="https://xsj12315.live.dynatrachtte.com/api"
API_TOKEN=ZHQwYzAxLlRLUjdaQkI3UkpERFlIUU01WVdFVUVCTy5GUlZCV1REUlVaQVdGUFRLN1o3VFRBN0tWUDc3Qk5WT1g3NExXSkZLUzM0U0tMVVZCNUlHNlpCSU9DNTNYQkNO
PAAS_TOKEN=ZHQwYzAxLlhUM1VPSVo2SVVVN0xDNkNMMktSQUJBUy4yWFBNM0FGUU5MNEg2MzZMNTdKUDZIU0JKRldJTlNXMlZRR09PVEZPMldLUFlOQlpaSko0TkpOSEk1NVhNM1M2
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
    sh ./install.sh --api-url $API_URL --api-token "dt0c01.DD5FGSRYRIPG657SLKLYTJIS.MKVUJZCRRCQQRKJDFZF5OG6ZQOWNRIA2GG4RWUS465Z7LW7F7RXN2JH5HLCGPWHO" --paas-token "dt0c01.J4TZF642SJGAQJJDHKMNCSBW.ANSPRUCFXGDOYJM7R3F6LCEYBPBWDIZOXIMFZ7WCMVWR3EUYVECVRSHBO4KIALLZ" --cluster-name "demo"
    ##sh ./${INSTALL_FILE}
    ##    -api-url  ${API_URL} 
    ##    --api-token $(eval echo ${API_TOKEN} | base64 --decode)
    ##    --paas-token $(eval echo ${PASS_TOKEN} | base64 --decode)
    ##    --cluster-name ${CLUSTER_NAME}
else 
    echo "Script has failed to run/execute" >&2
    exit 3
fi
