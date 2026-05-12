# PRD: Internal Developer Platform Lite

## 1. Project Name

**Internal Developer Platform Lite**

Alternative names:

```text
DevLaunch
EKS Launchpad
GitOps Deployment Platform
AppShip
PlatformLite
```

Recommended name:

```text
DevLaunch — Internal Developer Platform Lite
```

---

# 2. One-Line Description

A lightweight internal developer platform that allows developers to deploy containerized applications to **AWS EKS** using a simple YAML configuration, while the platform handles Docker builds, GitLab CI/CD, Helm generation, Flux GitOps deployment, Ingress routing, monitoring, and rollback.

---

# 3. Problem Statement

Developers often need to deploy applications to Kubernetes, but Kubernetes deployment requires knowledge of:

```text
Docker
Kubernetes YAML
Deployments
Services
Ingress
Helm
CI/CD
Monitoring
Resource limits
Secrets
Rollback
```

This creates friction between developers and DevOps teams.

In real companies, DevOps teams usually want to give developers a simple, standardized way to deploy services without letting every team write random Kubernetes manifests.

This project solves that by giving developers a simple config file like:

```yaml
app_name: payments-api
environment: staging
port: 8000
replicas: 2
image: payments-api:v1.0.0
domain: payments-staging.example.com
monitoring:
  enabled: true
```

Then the platform automatically generates and deploys the required Kubernetes resources.

---

# 4. Target Users

## Primary User

### Application Developer

A developer who wants to deploy an app without deeply understanding Kubernetes.

They care about:

```text
Pushing code
Building image
Deploying app
Seeing if it works
Rolling back if broken
```

They do not want to manually write Kubernetes YAML.

---

## Secondary User

### DevOps / Platform Engineer

A DevOps engineer who wants to standardize deployments.

They care about:

```text
Security
Consistency
Monitoring
Resource limits
Ingress rules
Rollback
GitOps
Auditability
```

---

# 5. Project Goal

The goal is to build a small but realistic platform that demonstrates how real DevOps/platform teams automate deployments.

The platform should allow a user to deploy an app by editing one simple YAML file.

---

# 6. Main Objective

Build a system where this input:

```yaml
app_name: orders-api
environment: staging
image: 123456789.dkr.ecr.eu-west-1.amazonaws.com/orders-api:v1.0.0
port: 8000
replicas: 2
domain: orders-staging.example.com

resources:
  cpu: "250m"
  memory: "512Mi"

monitoring:
  enabled: true
```

Produces and deploys:

```text
Kubernetes Deployment
Kubernetes Service
Ingress
Helm values
Prometheus ServiceMonitor
Grafana dashboard
Rollback metadata
```

---

# 7. Why This Project Is Valuable

This is not just:

```text
I deployed an app to Kubernetes.
```

This is:

```text
I built a small internal platform that automates Kubernetes deployments using GitOps.
```

That sounds much stronger in a DevOps internship interview.

It proves knowledge of:

```text
AWS
EKS
Docker
Kubernetes
GitLab CI/CD
Flux CD
Helm
Ingress
Prometheus
Grafana
Linux
Bash
Python automation
Networking
Monitoring
Troubleshooting
```

---

# 8. Scope

## In Scope

The project will include:

```text
Simple developer-facing YAML config
Config validation
Docker image build
GitLab CI/CD pipeline
Push image to Amazon ECR
Helm chart generation or Helm values generation
Flux CD GitOps deployment
Deployment to AWS EKS
Ingress exposure
Basic health checks
Prometheus metrics scraping
Grafana dashboard
Rollback workflow
Documentation
```

---

## Out of Scope for MVP

Do not include these in the first version:

```text
Full web UI
Multi-cloud support
Complex RBAC dashboard
Advanced cost management
Self-service database provisioning
Service mesh
Advanced canary traffic splitting
Enterprise SSO
Multi-tenant billing
```

These can be future improvements.

---

# 9. MVP Version

## MVP Goal

Deploy a sample app to EKS using a simple YAML config and a GitOps workflow.

The MVP should prove this flow:

```text
Developer updates app config
        ↓
GitLab CI validates config
        ↓
Docker image is built
        ↓
Image is pushed to ECR
        ↓
Helm values are generated
        ↓
Flux detects GitOps repo change
        ↓
App is deployed to EKS
        ↓
Ingress exposes the app
        ↓
Prometheus/Grafana monitor the app
```

---

# 10. MVP Features

## Feature 1: Simple App Configuration

The platform should accept a YAML file like:

```yaml
app_name: payments-api
environment: staging
image: payments-api
tag: v1.0.0
port: 8000
replicas: 2
domain: payments-staging.example.com

resources:
  cpu: "250m"
  memory: "512Mi"

health:
  path: /health
  initial_delay_seconds: 10

monitoring:
  enabled: true
  metrics_path: /metrics

deployment:
  strategy: rolling
```

---

## Feature 2: Config Validation

A Python script validates the YAML file before deployment.

It checks:

```text
app_name exists
environment exists
port is valid
replicas is valid
CPU/memory are provided
domain exists
health check path exists
deployment strategy is valid
```

Example command:

```bash
python platform-cli/validate.py apps/payments-api/app.yaml
```

If config is invalid, the pipeline fails.

Example error:

```text
ERROR: resources.memory is required
ERROR: port must be between 1 and 65535
```

---

## Feature 3: Docker Build

GitLab CI builds the application Docker image.

Example:

```text
Build Docker image
Tag image with commit SHA
Push image to Amazon ECR
```

Image format:

```text
<aws_account_id>.dkr.ecr.<region>.amazonaws.com/payments-api:<commit_sha>
```

---

## Feature 4: Helm Values Generation

The platform converts the developer YAML config into Helm values.

Input:

```yaml
app_name: payments-api
replicas: 2
port: 8000
```

Generated Helm values:

```yaml
nameOverride: payments-api

image:
  repository: 123456789.dkr.ecr.eu-west-1.amazonaws.com/payments-api
  tag: abc123

replicaCount: 2

service:
  port: 8000

ingress:
  enabled: true
  host: payments-staging.example.com
```

---

## Feature 5: GitOps Deployment with Flux CD

Flux watches the GitOps repo.

When Helm values change, Flux applies the new desired state to EKS.

Flux resources:

```text
GitRepository
Kustomization
HelmRelease
```

Flow:

```text
GitLab commits generated Helm values
        ↓
Flux detects commit
        ↓
Flux applies HelmRelease
        ↓
EKS updates workload
```

---

## Feature 6: Ingress Exposure

The platform exposes the app through Ingress.

Possible options:

```text
AWS Load Balancer Controller
NGINX Ingress Controller
```

For simplicity, use:

```text
NGINX Ingress Controller
```

For AWS realism, use:

```text
AWS Load Balancer Controller
```

Ingress example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: payments-api
spec:
  rules:
    - host: payments-staging.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: payments-api
                port:
                  number: 8000
```

---

## Feature 7: Health Checks

The platform should automatically configure:

```text
Readiness probe
Liveness probe
```

Example:

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 8000

livenessProbe:
  httpGet:
    path: /health
    port: 8000
```

---

## Feature 8: Monitoring

The platform adds monitoring support using:

```text
Prometheus
Grafana
```

If monitoring is enabled:

```yaml
monitoring:
  enabled: true
  metrics_path: /metrics
```

The platform creates:

```text
ServiceMonitor
Prometheus scrape config
Grafana dashboard JSON
```

Metrics to show:

```text
Pod CPU usage
Pod memory usage
Request count
Error count
Pod restarts
Deployment replica status
```

---

## Feature 9: Rollback

The platform should support rollback to the previous image version.

Rollback options:

```text
Helm rollback
Git revert
Flux reconciliation
```

Recommended MVP rollback:

```bash
helm rollback payments-api 1
```

Better GitOps rollback:

```bash
git revert <bad_commit>
git push
flux reconcile kustomization apps
```

Document both.

---

# 11. Version 2 Features

After the MVP, add these.

## Blue/Green Deployment

Allow this config:

```yaml
deployment:
  strategy: blue_green
  active_color: blue
```

The platform creates:

```text
payments-api-blue
payments-api-green
payments-api-service
```

Traffic is controlled by the Service selector:

```yaml
selector:
  app: payments-api
  color: blue
```

Switch traffic:

```bash
./scripts/switch-traffic.sh payments-api green
```

Rollback:

```bash
./scripts/switch-traffic.sh payments-api blue
```

---

## Secrets Management

Add secure secrets using:

```text
SOPS
AWS KMS
Flux CD
Kubernetes Secrets
```

Developer config:

```yaml
secrets:
  enabled: true
  provider: sops
```

---

## Alerting

Add Prometheus alert rules:

```text
High CPU usage
High memory usage
Pod crash looping
Too many 5xx errors
Deployment unavailable
```

Example:

```text
Alert if pod restarts more than 3 times in 5 minutes.
```

---

## Production Readiness Score

The platform scores apps before deployment.

Checks:

```text
Has resource limits
Has health checks
Has monitoring enabled
Uses fixed image tag, not latest
Has replicas >= 2 for staging/prod
Has ingress configured
Has rollback support
```

Example output:

```text
Production Readiness Score: 82/100
Warnings:
- No network policy configured
- Replicas should be at least 2
```

---

# 12. User Stories

## Developer User Stories

### Story 1

As a developer, I want to define my app deployment in one YAML file so that I do not need to manually write Kubernetes manifests.

### Story 2

As a developer, I want the platform to validate my config so that I can catch errors before deployment.

### Story 3

As a developer, I want GitLab CI to automatically build and push my Docker image so that I do not do it manually.

### Story 4

As a developer, I want my app to be deployed automatically after merging to main so that releases are simple.

### Story 5

As a developer, I want to see my app health in Grafana so that I know whether the deployment is working.

### Story 6

As a developer, I want rollback instructions so that I can recover quickly if a release fails.

---

## DevOps User Stories

### Story 1

As a DevOps engineer, I want all deployments to follow a standard Helm chart so that apps are consistent.

### Story 2

As a DevOps engineer, I want Flux to deploy from Git so that all changes are auditable.

### Story 3

As a DevOps engineer, I want every app to have resource requests and limits so that the cluster remains stable.

### Story 4

As a DevOps engineer, I want every app to have health checks so that Kubernetes can detect broken pods.

### Story 5

As a DevOps engineer, I want monitoring enabled by default so that production issues can be detected early.

---

# 13. Functional Requirements

## Config Management

The system must:

```text
Accept app configuration in YAML
Validate required fields
Reject invalid configs
Generate Helm values from config
Support multiple environments
```

---

## CI/CD

The system must:

```text
Run in GitLab CI
Build Docker image
Tag image with commit SHA
Push image to ECR
Run validation before deployment
Commit generated deployment files to GitOps repo
```

---

## GitOps

The system must:

```text
Use Flux CD
Watch GitLab GitOps repository
Apply Kubernetes resources automatically
Expose sync status
Allow manual reconciliation
```

---

## Kubernetes Deployment

The system must create:

```text
Deployment
Service
Ingress
ConfigMap
ServiceMonitor
Optional Secret
```

---

## Observability

The system must include:

```text
Prometheus metrics scraping
Grafana dashboard
Basic alerting rules
Pod restart visibility
CPU/memory visibility
Deployment health visibility
```

---

## Rollback

The system must support:

```text
Rollback using Git revert
Rollback using Helm history
Rollback documentation
```

---

# 14. Non-Functional Requirements

## Reliability

The platform should prevent invalid deployments by validating configs before applying changes.

## Security

The platform should avoid storing plaintext secrets in Git.

MVP can document this.

Version 2 should use:

```text
SOPS + AWS KMS
```

## Scalability

The platform should support multiple apps and environments.

Example:

```text
dev
staging
prod
```

## Maintainability

The project should have clear documentation and modular folders.

## Auditability

All deployment changes should be visible in Git history.

## Portability

The platform should be Kubernetes-based and not tightly coupled to only one application.

---

# 15. Technical Architecture

## High-Level Architecture

```text
Developer
   ↓
GitLab Application Repo
   ↓
GitLab CI/CD
   ↓
Docker Build
   ↓
Amazon ECR
   ↓
Platform CLI validates config
   ↓
Platform CLI generates Helm values
   ↓
GitOps Repo updated
   ↓
Flux CD watches GitOps Repo
   ↓
AWS EKS Cluster
   ↓
Kubernetes Deployment / Service / Ingress
   ↓
Prometheus + Grafana
```

---

# 16. Repositories

Recommended structure:

## Option A: Two Repositories

```text
app-repo/
  src/
  Dockerfile
  app.yaml
  .gitlab-ci.yml

gitops-repo/
  clusters/
  apps/
  helm/
  monitoring/
```

This is more realistic.

---

## Option B: One Repository

```text
internal-developer-platform-lite/
  sample-app/
  platform-cli/
  helm-chart/
  gitops/
  monitoring/
  scripts/
  docs/
```

This is easier for a portfolio project.

Recommended for you:

```text
Start with one repository.
Explain that in production, app repo and GitOps repo should be separated.
```

---

# 17. Suggested Folder Structure

```text
internal-developer-platform-lite/
│
├── sample-app/
│   ├── app/
│   │   └── main.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── app-configs/
│   └── payments-api.yaml
│
├── platform-cli/
│   ├── validate.py
│   ├── generate.py
│   ├── schemas/
│   │   └── app-config.schema.json
│   └── templates/
│       ├── values.yaml.j2
│       └── servicemonitor.yaml.j2
│
├── helm-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       ├── configmap.yaml
│       └── servicemonitor.yaml
│
├── gitops/
│   ├── clusters/
│   │   └── eks-staging/
│   │       ├── flux-system/
│   │       └── apps.yaml
│   └── apps/
│       └── payments-api/
│           ├── helmrelease.yaml
│           └── values.yaml
│
├── monitoring/
│   ├── prometheus-rules.yaml
│   └── grafana-dashboard.json
│
├── scripts/
│   ├── setup-eks.sh
│   ├── install-flux.sh
│   ├── rollback.sh
│   └── switch-traffic.sh
│
├── .gitlab-ci.yml
│
└── docs/
    ├── PRD.md
    ├── architecture.md
    ├── setup.md
    ├── deployment-flow.md
    ├── rollback.md
    └── troubleshooting.md
```

---

# 18. Example App Config

```yaml
app_name: payments-api
team: backend
environment: staging

image:
  repository: payments-api
  tag: latest

container:
  port: 8000

replicas: 2

domain: payments-staging.example.com

resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"

health:
  enabled: true
  path: /health
  initial_delay_seconds: 10

monitoring:
  enabled: true
  metrics_path: /metrics

deployment:
  strategy: rolling

env:
  APP_ENV: staging
  LOG_LEVEL: info
```

---

# 19. GitLab CI/CD Pipeline

Pipeline stages:

```yaml
stages:
  - validate
  - test
  - build
  - push
  - generate
  - update-gitops
```

## Stage 1: Validate

```text
Validate app.yaml
Validate Dockerfile exists
Validate required fields
```

## Stage 2: Test

```text
Run unit tests
Run linting
```

## Stage 3: Build

```text
Build Docker image
```

## Stage 4: Push

```text
Push image to ECR
```

## Stage 5: Generate

```text
Generate Helm values
Generate ServiceMonitor if monitoring enabled
```

## Stage 6: Update GitOps

```text
Commit generated files to GitOps folder/repo
Flux handles deployment
```

---

# 20. Deployment Strategies

## MVP Strategy

Use normal rolling deployment.

```yaml
deployment:
  strategy: rolling
```

This is easiest.

---

## Advanced Strategy

Support blue/green deployment.

```yaml
deployment:
  strategy: blue_green
  active_color: blue
```

Blue/green creates:

```text
payments-api-blue
payments-api-green
payments-api-service
```

Traffic switch is done by changing selector:

```yaml
color: blue
```

to:

```yaml
color: green
```

---

# 21. Monitoring Requirements

Grafana dashboard should show:

```text
App status
Pod count
Available replicas
CPU usage
Memory usage
Pod restarts
Request rate
Error rate
Ingress traffic
```

Prometheus alert examples:

```text
PodCrashLooping
HighMemoryUsage
HighCPUUsage
DeploymentUnavailable
HighErrorRate
```

---

# 22. Success Metrics

The project is successful if:

```text
A developer can deploy an app using only one YAML config
GitLab CI builds and pushes the Docker image
Flux deploys the app to EKS
Ingress exposes the app
Prometheus scrapes app metrics
Grafana displays app health
Rollback is documented and tested
The project can be explained clearly in an interview
```

---

# 23. Demo Scenario

Your demo should follow this exact story:

## Demo 1: Deploy New App

```text
1. Show simple app config
2. Push change to GitLab
3. Pipeline validates config
4. Pipeline builds image
5. Image pushed to ECR
6. GitOps files updated
7. Flux deploys app to EKS
8. App is accessible through Ingress
9. Grafana shows metrics
```

---

## Demo 2: Bad Config Fails

Change this:

```yaml
replicas: wrong
```

Pipeline should fail with:

```text
replicas must be an integer
```

This proves validation.

---

## Demo 3: Rollback

Deploy broken app version.

Then rollback using:

```bash
git revert <commit>
git push
flux reconcile kustomization apps
```

This proves operational thinking.

---

## Demo 4: Monitoring

Show Grafana dashboard:

```text
CPU
Memory
Restarts
Availability
Request rate
```

---

# 24. Risks

## Risk 1: EKS Cost

EKS can cost money.

Mitigation:

```text
Use small node group
Delete cluster after demo
Use local Kind cluster for development
Use EKS only for final demo
```

---

## Risk 2: Project Becomes Too Big

Mitigation:

```text
Do not build UI first
Do not support many apps at first
Do not add secrets in MVP
Start with one app, one environment
```

---

## Risk 3: Flux Setup Complexity

Mitigation:

```text
First deploy manually with Helm
Then add Flux
Document both
```

---

## Risk 4: Monitoring Takes Time

Mitigation:

```text
Use kube-prometheus-stack Helm chart
Use a basic Grafana dashboard first
```

---

# 25. Implementation Phases

## Phase 1: Local Foundation

```text
Create FastAPI app
Create Dockerfile
Run locally
Create app.yaml
Create validation script
Create Helm chart
Deploy to local Kind or Minikube
```

---

## Phase 2: AWS Deployment

```text
Create EKS cluster
Create ECR repo
Push Docker image to ECR
Deploy app to EKS using Helm
Expose with Ingress
```

---

## Phase 3: GitLab CI/CD

```text
Create GitLab pipeline
Build image
Push to ECR
Run validation
Generate Helm values
```

---

## Phase 4: Flux GitOps

```text
Install Flux
Connect Flux to GitLab repo
Create HelmRelease
Test automatic deployment
```

---

## Phase 5: Observability

```text
Install Prometheus
Install Grafana
Add ServiceMonitor
Create dashboard
Add basic alerts
```

---

## Phase 6: Advanced Feature

Choose one:

```text
Blue/Green deployment
Secrets with SOPS
Production readiness checker
Rollback automation
```

Recommended:

```text
Blue/Green deployment
```

---

# 26. Interview Pitch

Use this:

> I built an Internal Developer Platform Lite on AWS EKS that allows developers to deploy containerized applications using a simple YAML file. The platform validates the config, builds Docker images through GitLab CI/CD, pushes them to ECR, generates Helm values, and uses Flux CD to deploy through GitOps. It also includes Ingress routing, Prometheus monitoring, Grafana dashboards, and rollback workflows.

Shorter version:

> I built a lightweight platform that abstracts Kubernetes complexity for developers by turning simple service configs into production-ready EKS deployments using GitLab CI/CD, Flux, Helm, Prometheus, and Grafana.

---

# 27. CV Bullet

Use this in your CV:

> Built an Internal Developer Platform Lite on AWS EKS enabling developers to deploy containerized applications through simple YAML service definitions; automated Docker builds, ECR image pushes, Helm values generation, Flux CD GitOps deployments, Ingress routing, Prometheus monitoring, Grafana dashboards, and rollback workflows.

Shorter:

> Built a GitOps-based Internal Developer Platform using AWS EKS, GitLab CI/CD, Flux CD, Helm, Docker, Prometheus, and Grafana to automate Kubernetes application deployments from simple YAML configs.

---

# 28. Final MVP Definition

Your MVP should be:

```text
A FastAPI sample app
Dockerized app
GitLab CI/CD pipeline
ECR image push
Simple app.yaml config
Python validation script
Helm chart
Flux GitOps deployment to EKS
Ingress exposure
Prometheus + Grafana monitoring
Rollback documentation
```

That is enough to be a **serious DevOps internship project**.