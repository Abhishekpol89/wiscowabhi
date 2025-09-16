🐮 Wisecow on Kubernetes with CI/CD & TLS
📌 Project Overview

The goal of this project was to containerize and deploy the Wisecow application into a Kubernetes cluster, expose it via Ingress, secure it with TLS certificates, and prepare it for CI/CD automation.

⚙️ Steps Performed
1. Containerization

Created a Dockerfile for Wisecow app.

Built and pushed the image to the registry.
Commands used:
docker build -t <your-dockerhub-user>/wisecow .
docker push <your-dockerhub-user>/wisecow

2. Kubernetes Deployment & Service

Created wisecow-deployment.yaml for deploying pods.

Created wisecow-service.yaml of type NodePort to expose the app.
Applied with:
kubectl apply -f wisecow-deployment.yaml
kubectl apply -f wisecow-service.yaml

Verified pods with:
kubectl get pods

Verified service with:
kubectl get svc

3. Ingress Setup

Installed NGINX Ingress Controller in ingress-nginx namespace.

Created wisecow-ingress.yaml to route traffic from wisecow.local → wisecow-service.
Applied with:
kubectl apply -f wisecow-ingress.yaml

4. Hosts File Update

Added entry to /etc/hosts so wisecow.local resolves to Minikube IP:
192.168.49.2 wisecow.local

5. TLS Configuration

Generated self-signed certificate:
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout wisecow.local.key -out wisecow.local.crt -subj "/CN=wisecow.local/O=wisecow.local"

Created Kubernetes TLS secret:
kubectl create secret tls wisecow-tls --key wisecow.local.key --cert wisecow.local.crt

Updated wisecow-ingress.yaml to use TLS.

🛑 Issues Faced & Fixes

Pod not accessible initially

Cause: Service misconfigured.

Fix: Corrected NodePort and matched targetPort.

Ingress not routing

Cause: Missing hosts entry (/etc/hosts not updated).

Fix: Added 192.168.49.2 wisecow.local.

Curl to service failing

Cause: Tried accessing service from outside cluster.

Fix: Tested with kubectl run debug --image=curlimages/curl.

Git push rejected

Cause: Remote repo had commits not in local.

Fix: Used git pull --rebase before pushing again.

🚀 End Goal

✅ Wisecow containerized and running on Kubernetes.

✅ Exposed via NodePort and Ingress.

✅ Secured with TLS.

🔜 Next: Setup GitHub Actions / Jenkins for automated CI/CD.

📝 Author

Abhishek Pol
DevOps Enthusiast | Cloud & Kubernetes Learner
