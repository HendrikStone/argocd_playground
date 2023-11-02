Internet ←-> AWS ELB ←-> k8s ingress ←-> k8s service ←-> k8s pods

Ziel:
Local Net ←-> Minikube ←-> k8s ingress ←-> k8s service ←-> k8s pods

Troubleshooting:
- Traffic walkthrough from the right to the left
https://medium.com/@ManagedKube/kubernetes-troubleshooting-ingress-and-services-traffic-flows-547ea867b120

1. Make sure k8s pods are running
kubectl get pods -o wide --namespace sample-app

Check logs:
kubectl logs backend-app-dev-5c774f4769-v2cz9 --namespace sample-app
kubectl logs backend-app-dev-5c774f4769-zkn9z --namespace sample-app

Connect to pod
kubectl exec -it backend-app-dev-5c774f4769-zkn9z --namespace sample-app -- sh
wget localhost:3000
cat index.html


2. Check k8s service
kubectl get service --namespace sample-app

kubectl describe service backend-app-dev --namespace sample-app

3. Check k8s Ingress
kubectl get ingress --namespace sample-app

kubectl describe ingress backend-app-dev --namespace sample-app