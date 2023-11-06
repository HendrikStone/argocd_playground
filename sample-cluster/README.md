Internet ←-> AWS ELB ←-> k8s ingress ←-> k8s service ←-> k8s pods

Ziel:
Local Net ←-> Minikube ←-> k8s ingress ←-> k8s service ←-> k8s pods

Prerequisites:
Install Minikube
https://minikube.sigs.k8s.io/docs/start/

Start Minikube with docker
https://minikube.sigs.k8s.io/docs/drivers/docker

Install ArgoCD
->kubectl create namespace argocd
->kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Enable Port Forwaring
->kubectl port-forward svc/argocd-server -n argocd 8080:443
=> localhost:8080

Get Password
->kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

Enable ingress:
https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/

->minikube addons enable ingress  
->minikube addons enable ingress-dns
->kubectl get pods --all-namespaces

Ermitteln IP
->minikube ip 

Troubleshooting:
- Traffic walkthrough from the right to the left
https://medium.com/@ManagedKube/kubernetes-troubleshooting-ingress-and-services-traffic-flows-547ea867b120

1. Make sure k8s pods are running
->kubectl get pods -o wide --namespace sample-app

Check logs:
->kubectl logs backend-app-dev-5c774f4769-v2cz9 --namespace sample-app
->kubectl logs backend-app-dev-5c774f4769-zkn9z --namespace sample-app

Connect to pod
->kubectl exec -it backend-app-dev-5c774f4769-zkn9z --namespace sample-app -- sh
->wget localhost:3000
->cat index.html

2. Check k8s service
->kubectl get service --namespace sample-app

->kubectl describe service backend-app-dev --namespace sample-app

3. Check k8s Ingress
->kubectl get ingress --namespace sample-app

->kubectl describe ingress backend-app-dev --namespace sample-app

->kubectl exec -it ingress-nginx-controller-7799c6795f-cf8d4 --namespace ingress-nginx -- sh

->curl -H "HOST:backend.sample-app.internal" localhost

4. Setup ingress DNS
Create a file in /etc/resolver/minikube-dev with the following contents.

domain dev
nameserver 192.168.49.2
search_order 1
timeout 5
Replace 192.168.49.2 with your minikube ip.

Get resolver 
scutil --dns



5. Install Traefik
# Install Traefik Resource Definitions:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

# Install RBAC for Traefik:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml