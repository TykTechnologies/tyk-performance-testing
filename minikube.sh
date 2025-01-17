minikube start --nodes=15
minikube addons enable ingress

kubectl label nodes minikube node=dependencies
kubectl label nodes minikube-m02 node=tyk
kubectl label nodes minikube-m03 node=tyk-upstream
kubectl label nodes minikube-m04 node=tyk-tests
kubectl label nodes minikube-m05 node=tyk-resources
kubectl label nodes minikube-m06 node=kong
kubectl label nodes minikube-m07 node=kong-upstream
kubectl label nodes minikube-m08 node=kong-tests
kubectl label nodes minikube-m09 node=kong-resources
kubectl label nodes minikube-m10 node=gravitee
kubectl label nodes minikube-m11 node=gravitee-upstream
kubectl label nodes minikube-m12 node=gravitee-tests
kubectl label nodes minikube-m13 node=gravitee-resources
kubectl label nodes minikube-m14 node=upstream
kubectl label nodes minikube-m15 node=upstream-tests
