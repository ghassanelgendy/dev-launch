# DevLaunch — Internal Developer Platform Lite

DevLaunch is a lightweight internal developer platform that lets developers deploy containerized apps to **AWS EKS** using a single YAML config, while the platform automates validation, image build/push, Helm values generation, Flux GitOps deployment, ingress exposure, monitoring, and rollback workflows.

## One-Line Value

Turn a simple app config into a production-style Kubernetes deployment flow:

**Config → Validate → Build → Push (ECR) → Generate Helm values → Flux deploys to EKS → Ingress + Monitoring + Rollback**

## Problem It Solves

Kubernetes delivery usually requires deep knowledge of Docker, manifests, CI/CD, Helm, ingress, monitoring, and rollback.

DevLaunch gives developers a standardized, low-friction path to ship services while keeping DevOps controls, consistency, and auditability.

## Target Users

- **Primary:** Application Developers
- **Secondary:** DevOps / Platform Engineers

## MVP Scope

### In Scope

- Developer-facing YAML app config
- Config validation CLI (Python)
- Docker image build
- GitLab CI/CD pipeline
- Push images to Amazon ECR
- Helm values generation
- Flux CD GitOps deployment to EKS
- Ingress exposure
- Health checks
- Prometheus + Grafana integration
- Rollback workflow + docs

### Out of Scope (MVP)

- Full web UI
- Multi-cloud support
- Advanced RBAC dashboard
- Advanced cost controls
- Service mesh
- Enterprise SSO

## End-to-End MVP Flow

1. Developer updates app config
2. GitLab CI validates config
3. Docker image is built
4. Image is pushed to ECR
5. Platform generates Helm values
6. GitOps state is updated
7. Flux detects change and reconciles
8. App is deployed to EKS
9. Ingress exposes the service
10. Prometheus/Grafana provide visibility

## Example Developer Config

```yaml
app_name: payments-api
team: backend
environment: staging

image:
  repository: payments-api
  tag: v1.0.0

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

## Config Validation Requirements

Validation should fail fast if required fields are missing or invalid:

- configuration keys use `snake_case` (for example, `app_name`, `initial_delay_seconds`)
- `app_name`, `environment`, `domain`
- valid `container.port` (1–65535; ports below 1024 may require elevated privileges, so prefer `>=1024` for standard app containers)
- integer `replicas`
- resource requests/limits
- health path when health is enabled
- valid deployment strategy (`rolling` for MVP)

Example:

```bash
python platform-cli/validate.py app-configs/payments-api.yaml
```

## Suggested Repository Structure

```text
dev-launch/
├── sample-app/
│   ├── app/main.py
│   ├── requirements.txt
│   └── Dockerfile
├── app-configs/
│   └── payments-api.yaml
├── platform-cli/
│   ├── validate.py
│   ├── generate.py
│   ├── schemas/app-config.schema.json
│   └── templates/
│       ├── values.yaml.j2
│       └── servicemonitor.yaml.j2
├── helm-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       ├── configmap.yaml
│       └── servicemonitor.yaml
├── gitops/
│   ├── clusters/eks-staging/apps.yaml
│   └── apps/payments-api/
│       ├── helmrelease.yaml
│       └── values.yaml
├── monitoring/
│   ├── prometheus-rules.yaml
│   └── grafana-dashboard.json
├── scripts/
│   ├── setup-eks.sh
│   ├── install-flux.sh
│   ├── rollback.sh
│   └── switch-traffic.sh
├── .gitlab-ci.yml
└── docs/
    ├── PRD.md
    ├── architecture.md
    ├── setup.md
    ├── deployment-flow.md
    ├── rollback.md
    └── troubleshooting.md
```

## CI/CD Pipeline (GitLab)

Recommended stages:

```yaml
stages:
  - validate
  - test
  - build
  - push
  - generate
  - update-gitops
```

### Stage Expectations

- **validate:** app config + Dockerfile checks
- **test:** unit tests + lint
- **build:** build Docker image
- **push:** push image to ECR
- **generate:** create Helm values + ServiceMonitor values
- **update-gitops:** commit generated state for Flux reconciliation

Image convention:

```text
<aws_account_id>.dkr.ecr.<region>.amazonaws.com/<app_name>:<commit_sha>
```

Recommended tagging strategy for easier rollback and traceability:

- immutable commit SHA tag (required)
- optional semantic version tag (for example, `v1.2.0`)

## GitOps with Flux CD

Flux resources used:

- `GitRepository`
- `Kustomization`
- `HelmRelease`

Deployment flow:

1. Pipeline updates GitOps manifests/values
2. Flux detects commit
3. Flux reconciles desired state
4. EKS updates workload

## Kubernetes Resources Generated

- Deployment
- Service
- Ingress
- ConfigMap
- ServiceMonitor (when monitoring enabled)
- Optional Secret (future with SOPS/KMS)

## Ingress, Health, and Monitoring

### Ingress

- Host-based route from config domain to service/port
- MVP can use NGINX ingress controller
- AWS-realistic option: AWS Load Balancer Controller

### Health Checks

- Readiness and liveness probes from config (`/health` by default)

### Monitoring

When enabled, platform provides:

- Prometheus scraping (ServiceMonitor)
- Grafana dashboard
- Core views: CPU, memory, restarts, replicas, request/error rates

## Rollback

Two rollback paths should be documented and tested:

### Helm rollback (fast)

```bash
helm history payments-api
helm rollback payments-api 1
```

### GitOps rollback (preferred for auditability)

```bash
git revert <bad_commit>
git push
flux reconcile kustomization apps
```

## Demo Scenarios

1. **Deploy new app** end-to-end
2. **Bad config fails** validation (e.g., `replicas: wrong`)
3. **Rollback** failed release
4. **Monitoring** confirms service health

## Success Criteria

Project is successful when:

- Developers deploy via one YAML file
- CI builds/pushes image to ECR
- Flux deploys to EKS
- App is reachable via ingress
- Prometheus/Grafana show app health
- Rollback is clear and repeatable
