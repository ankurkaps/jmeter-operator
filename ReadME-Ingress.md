
Reference:

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm

1. Install helm

2. Add repositories for certmanager and nginx ingress

```
helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

3. Create namespace cert-manager and use helm to deploy certmanager

```
kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.2.0 --set installCRDs=true
```

4. Deploy production cluster issuer
```
kubectl apply -f production_issuer.yaml
```

5. Use helm to install nginx-ingress

```
helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true
kubectl --namespace default get services -o wide -w nginx-ingress-ingress-nginx-controller
```

6. Deploy ingress

```
kubectl apply -f nginx-ingress.yaml
```


