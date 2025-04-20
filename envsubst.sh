#!/usr/bin/bash

export CLUSTER_STORAGE=$1
export NAMESPACE=$2
export PV_MOUNT_PATH=$3

echo -e "-------------- INITIALIZE KUBERNETES CLUSTER ------------\n"

echo "What you want to do?" 
echo -e "1) Apply Service files\n2) Apply Storage files\n3) Apply Security Files\n4) Apply Deployment Files\n5) Create Zabbix DB Schema\n6) Delete all\n7)Exit\n"

read OPTION 

case $OPTION in 

    1) 
        envsubst < service/DBService.yaml | kubectl apply -f -
        envsubst < service/ZabbixFrontendService.yaml | kubectl apply -f -
        envsubst < service/GrafanaService.yaml | kubectl apply -f -
        envsubst < service/ZabbixServerService.yaml | kubectl apply -f - 
        ;;

    2) 

        envsubst < storage/PV.yaml | kubectl apply -f -
        kubectl apply -f storage/PVC.yaml
        ;;

    3) 

        envsubst < security/PostgresSecret.yaml | kubectl apply -f -
        envsubst < security/ZabbixSecret.yaml | kubectl apply -f -
        ;;
    
    4)
        envsubst < deployment/PostgresStatefulSet.yaml | kubectl apply -f -
        envsubst < deployment/GrafanaDeployment.yaml | kubectl apply -f -
        envsubst < deployment/ZabbixFronEndDeployment.yaml | kubectl apply -f -
        envsubst < deployment/ZabbixServerDeployment.yaml | kubectl apply -f -
        ;;

    5) 
        
        kubectl get pods -o wide
        echo -e "Type the database deployment name:\n"
        read POSTGRES_DEPLOYMENT_NAME
        
        `kubectl exec -it ${POSTGRES_DEPLOYMENT_NAME} -- psql -U zabbix -d zabbix < create.sql`

        ;;

    6) 

        ## DELETE NAMESPACE
        
        envsubst < Namespace.yaml | kubectl delete -f -


        ;;

    *) 
        echo "Invalid option!"
        ;;
esac
        
