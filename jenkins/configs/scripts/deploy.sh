#! /bin/bash

image_name=$1:$2


if [[ -f whanos.yml ]]; then
	helm upgrade -if whanos.yml "$3" /helm/whanosDeploy --set container.image=$image_name --set container.name="container-$3"
    
    ip=""
    to=30
    while [[ $ip == "" ]]; do
        if [[ $to == 0 ]]; then
            echo "Timeout while waiting for the service to be ready."
            exit 1
        fi
        sleep 1
        to=$((to-1))
        ip=$(kubectl get svc "$3"-service -n whanos -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    done

    echo "Service is ready at address -> '$ip'"
fi