#!/bin/bash


#set proxy
export http_proxy=http://web-proxy.in.softwaregrp.net:8080
export https_proxy=http://web-proxy.in.softwaregrp.net:8080
export HTTP_PROXY=http://web-proxy.in.softwaregrp.net:8080
export HTTPS_PROXY=http://web-proxy.in.softwaregrp.net:8080


##helm installation
socat -V
if [ $? -eq 0 ]; then
    echo "socat is already installed"
else 
    echo "installing socat"
    yum install -y socat
fi
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

kubectl create -f rbac-config.yaml
helm init --service-account tiller --history-max 200

helm install stable/prometheus --values prometheus.values  --name prometheus --namespace monitoring
helm install stable/grafana --values grafana.values  --name grafana --namespace monitoring
kubectl create -f pv_prometheus.yaml -f pv_alertmanager.yaml
kubectl create -f ingress_prometheus_grafana.yaml
