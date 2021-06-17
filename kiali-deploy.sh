#!/bin/bash
n=0
until [ "$n" -ge 5 ]
do
	kubectl apply -f kiali.yaml && break  # kiali deployment failed to apply in the first attemp so I decide to retry
	n=$((n+1))
	sleep 15
done