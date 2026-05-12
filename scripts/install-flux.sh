#!/bin/bash

# Check if flux is installed
if ! command -v flux &> /dev/null
then
    echo "flux could not be found. Please install it first."
    exit 1
fi

# You need these environment variables set:
# GITHUB_TOKEN or GITLAB_TOKEN
# GITHUB_USER or GITLAB_USER

echo "Bootstrapping Flux CD on EKS cluster..."

# Example for GitLab (as per PRD)
flux bootstrap gitlab \
  --owner=$GITLAB_USER \
  --repository=dev-launch \
  --branch=main \
  --path=gitops/clusters/eks-staging \
  --personal \
  --token-auth
