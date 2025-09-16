# Wisecow Kubernetes Deployment

This project demonstrates the containerization and deployment of the **Wisecow application** into a Kubernetes environment, secured with TLS and automated using a CI/CD pipeline.

---

## Steps Completed
- Set up EC2 instance (Amazon Linux 2023) and installed `kubectl`, `docker`, `minikube`, and `helm`.
- Cloned Wisecow repository, built Docker image, and pushed it to Amazon ECR (public).
- Created Kubernetes manifests for Deployment, Service, and Ingress, and applied them.
- Installed NGINX Ingress Controller with Helm and verified successful installation.
- Exposed Wisecow service as NodePort and tested using:
  ```bash
  curl -H "Host: wisecow.local" http://192..49.2168

  Issues Faced

Ingress not accessible via browser even after updating Security Groups (Minikube ingress works locally, needs LoadBalancer on EC2).

Wisecow service only accessible internally via NodePort/ClusterIP, not directly through EC2 public IP.

Next Steps

Configure LoadBalancer Ingress for external access on EC2.

Enable TLS using cert-manager or manual certificates.

Automate pipeline with GitHub Actions or Jenkins:

Build Docker image → Push to ECR → Deploy to Kubernetes.

End Goal

Containerized Wisecow application.

Kubernetes deployment with CI/CD.

TLS-secured ingress for secure communication.

Public GitHub repository for transparency.


