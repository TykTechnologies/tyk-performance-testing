minikube start --nodes=4
minikube addons enable ingress

kubectl label nodes minikube node=resources
kubectl label nodes minikube-m02 node=tyk
kubectl label nodes minikube-m03 node=kong
kubectl label nodes minikube-m04 node=gravitee
