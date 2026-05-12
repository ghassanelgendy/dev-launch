#!/bin/bash

CLUSTER_NAME="devlaunch-cluster"

echo "Creating Kind cluster: $CLUSTER_NAME..."
kind create cluster --name $CLUSTER_NAME

echo "Loading application image into Kind..."
docker build -t devlaunch-app:v1.0.0 ./sample-app
kind load docker-image devlaunch-app:v1.0.0 --name $CLUSTER_NAME

echo "Deploying application manually (Exploratory)..."
kubectl apply -f k8s-manual/deployment.yaml
kubectl apply -f k8s-manual/service.yaml

echo "Waiting for pods..."
kubectl wait --for=condition=ready pod -l app=devlaunch-app --timeout=60s

echo "Setup complete. You can access the app via port-forward:"
echo "kubectl port-forward svc/devlaunch-service 8080:80"
