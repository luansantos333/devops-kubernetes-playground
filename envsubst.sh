#!/usr/bin/bash

echo -e "-------------- INITIALIZE KUBERNETES CLUSTER ------------\n"

echo "What you want to do?" 
echo -e "1)Create kind cluster\n2)Apply Service files\n3)Apply Storage files\n4)Apply Security Files\n5)Apply Deployment Files\n6)Create Zabbix DB Schema\n7)Delete all\n8)Exit\n"

read OPTION 

case $OPTION in 

    1) 
        echo -e "Cluster name:"
        read CLUSTER_NAME
        echo -e "Storage for cluster data:"
        read CLUSTER_STORAGE
        echo -e "Namespace:"
        read NAMESPACE

        export CLUSTER_NAME
        export CLUSTER_STORAGE
        export NAMESPACE

        envsubst < cluster/config.yaml | kind create cluster --config -
        envsubst < Namespace.yaml | kubectl apply -f -
        kubens $NAMESPACE
        ;;


    2) 
        envsubst < service/DBService.yaml | kubectl apply -f -
        envsubst < service/ZabbixFrontendService.yaml | kubectl apply -f -
        envsubst < service/GrafanaService.yaml | kubectl apply -f -
        envsubst < service/ZabbixHAServerService.yaml | kubectl apply -f - 
        ;;

    3) 

        echo -e "Pod storage:"
        read PV_MOUNT_PATH
        export PV_MOUNT_PATH
        envsubst < storage/PV.yaml | kubectl apply -f -
        kubectl apply -f storage/PVC.yaml
        ;;

    4) 

        envsubst < security/PostgresSecret.yaml | kubectl apply -f -
        envsubst < security/ZabbixSecret.yaml | kubectl apply -f -
        ;;
    
    5)
        envsubst < deployment/PostgresStatefulSet.yaml | kubectl apply -f -
        envsubst < deployment/GrafanaDeployment.yaml | kubectl apply -f -
        envsubst < deployment/ZabbixFronEndDeployment.yaml | kubectl apply -f -
        envsubst < deployment/ZabbixServerHAStatefulSet.yaml | kubectl apply -f -
        ;;

    6) 
        
        kubectl get pods -o wide
        echo -e "Type the database deployment name:\n"
        read POSTGRES_DEPLOYMENT_NAME
        
        `kubectl exec -it ${POSTGRES_DEPLOYMENT_NAME} -- psql -U zabbix -d zabbix < create.sql`
         ;;

    7) 
        ## DELETE NAMESPACE
        envsubst < Namespace.yaml | kubectl delete -f -
        ;;
    8) 

        echo "Exiting..."
        ;;

    *) 
        echo "Invalid option!"
        ;;
esac
        
