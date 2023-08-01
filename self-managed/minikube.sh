minikube start --nodes=5
minikube addons enable ingress

kubectl label nodes minikube node=upstream
kubectl label nodes minikube-m02 node=resources
kubectl label nodes minikube-m02 node=tyk
kubectl label nodes minikube-m03 node=kong
kubectl label nodes minikube-m04 node=gravitee
