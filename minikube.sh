minikube start --nodes=13
minikube addons enable ingress

kubectl label nodes minikube node=dependencies
kubectl label nodes minikube-m02 node=tyk
kubectl label nodes minikube-m02 node=tyk-upstream
kubectl label nodes minikube-m03 node=tyk-tests
kubectl label nodes minikube-m04 node=tyk-resources
kubectl label nodes minikube-m05 node=kong
kubectl label nodes minikube-m06 node=kong-upstream
kubectl label nodes minikube-m07 node=kong-tests
kubectl label nodes minikube-m08 node=kong-resources
kubectl label nodes minikube-m09 node=gravitee
kubectl label nodes minikube-m10 node=gravitee-upstream
kubectl label nodes minikube-m11 node=gravitee-tests
kubectl label nodes minikube-m12 node=gravitee-resources
