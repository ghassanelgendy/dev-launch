# Learning & Implementation Plan: Internal Developer Platform Lite

This plan is designed to help you build a professional-grade DevOps project while mastering the underlying technologies (Docker, Kubernetes, EKS, Terraform, GitOps) required for a DevOps internship.

---

## 🛠 Phase 1: The App & Docker Fundamentals
**Goal:** Understand how to containerize an application.

1.  **Develop the App:** Create a simple "Hello World" API using Python (FastAPI or Flask).
2.  **Containerize:** Write a `Dockerfile` for the app.
3.  **Optimize:** Use multi-stage builds to keep the image small.
4.  **Local Test:** Build the image (`docker build`) and run it locally (`docker run`).
5.  **Learning Outcomes:**
    *   What are Docker images and containers?
    *   Docker layers and caching.
    *   Environment variables in Docker.
    *   Port mapping.

---

## ☸️ Phase 2: Local Kubernetes (The Hard Way)
**Goal:** Understand Kubernetes primitives without the abstraction of Helm or Cloud.

1.  **Cluster Setup:** Install `kind` (Kubernetes in Docker) or `minikube`.
2.  **Manual Manifests:** Write raw YAML files:
    *   `deployment.yaml`: Define replicas, image, and resource limits.
    *   `service.yaml`: Expose the app internally (ClusterIP).
3.  **Imperative Commands:** Use `kubectl` to apply manifests, check logs, and exec into pods.
4.  **Local Exposure:** Use `kubectl port-forward` to access your app.
5.  **Learning Outcomes:**
    *   Pods, Deployments, and ReplicaSets.
    *   Services and Service Discovery.
    *   The Kubernetes Object Model.
    *   Troubleshooting with `kubectl`.

---

## 🏗 Phase 3: The "Platform" Logic (Helm & Python)
**Goal:** Build the abstraction layer that makes life easy for developers.

1.  **Helm Chart:** Convert your raw YAML into a generic Helm chart with templates.
2.  **Developer Config:** Create a sample `app.yaml` (the developer's interface).
3.  **CLI Automation:** Write a Python script (`validate.py`) to validate `app.yaml` using JSON Schema.
4.  **Generation:** Write a Python script (`generate.py`) that reads `app.yaml` and produces a Helm `values.yaml` file.
5.  **Learning Outcomes:**
    *   Helm templating and `values.yaml`.
    *   Dry-run and debug Helm releases.
    *   Python for DevOps automation.
    *   Validation logic and error handling.

---

## ☁️ Phase 4: Infrastructure & Cloud (Terraform & AWS)
**Goal:** Use Infrastructure as Code (IaC) to provision cloud resources.

1.  **Terraform Basics:** Set up Terraform to manage AWS resources.
2.  **Registry:** Provision an Amazon ECR (Elastic Container Registry) repository.
3.  **Compute:** Provision a minimal AWS EKS (Elastic Kubernetes Service) cluster.
    *   *Note: Use a small node group to save cost.*
4.  **Learning Outcomes:**
    *   Terraform providers and state management.
    *   AWS Networking (VPC, Subnets, Security Groups).
    *   EKS Architecture (Control Plane vs. Data Plane).
    *   IAM roles for Service Accounts (IRSA).

---

## 🚀 Phase 5: Continuous Integration (GitLab CI)
**Goal:** Automate the "Push to Deploy" flow.

1.  **Pipeline Construction:** Create a `.gitlab-ci.yml` file.
2.  **Stages:**
    *   `validate`: Run your Python validation script.
    *   `build`: Build the Docker image.
    *   `push`: Push the image to AWS ECR.
3.  **OIDC Auth:** Configure GitLab to authenticate with AWS securely (no static keys).
4.  **Learning Outcomes:**
    *   CI/CD pipeline design.
    *   Docker-in-Docker (DinD).
    *   Secure secret management in CI.

---

## 🔄 Phase 6: GitOps (Flux CD)
**Goal:** Implement declarative, self-healing deployments.

1.  **Flux Installation:** Install Flux CD on your EKS cluster.
2.  **Source Controller:** Tell Flux to watch your Git repository.
3.  **Kustomization:** Configure Flux to apply your generated Helm values automatically.
4.  **Git-Back Flow:** Have your CI pipeline commit the generated `values.yaml` back to Git, triggering Flux.
5.  **Learning Outcomes:**
    *   Push-based vs. Pull-based deployment.
    *   The GitOps loop and drift detection.
    *   Flux Custom Resources (GitRepository, HelmRelease).

---

## 📊 Phase 7: Observability (Prometheus & Grafana)
**Goal:** Prove the platform is healthy and production-ready.

1.  **Monitoring Stack:** Install the `kube-prometheus-stack` via Helm.
2.  **Metrics Export:** Ensure your platform logic generates a `ServiceMonitor`.
3.  **Dashboards:** Import a basic Grafana dashboard to visualize CPU/Memory/Requests.
4.  **Learning Outcomes:**
    *   Metrics scraping vs. pushing.
    *   Prometheus Query Language (PromQL).
    *   Alerting fundamentals.

---

## ✅ Final Success Checklist
- [ ] Can I deploy a new service by only touching one `app.yaml`?
- [ ] Does the CI pipeline fail if the config is invalid?
- [ ] Is my EKS infrastructure managed entirely by Terraform?
- [ ] Can I explain the flow from `git push` to `pod running` in an interview?