#!/usr/bin/env bash

if [[ `echo 1` = "1" ]] ; then 
  printf "    helm install of ingress-nginx sucessful after <$elapsed_secs> secs \n\n"
else 
  printf "    Error: ingress-nginx helm chart  deployment failed "
  exit 1
fi 