#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Install ArgoCD Image Updater on GKE
# Polls Google Artifact Registry and auto-commits tag changes to gitops-cd
# =============================================================================

echo "=== Installing ArgoCD Image Updater ==="

# 1. Create namespace
kubectl create namespace argocd-image-updater --dry-run=client -o yaml | kubectl apply -f -

# 2. Install Image Updater via official manifests
kubectl apply -n argocd-image-updater \
  -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

# 3. Apply our custom config (GAR registry, git write-back)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "${SCRIPT_DIR}/config.yaml"

echo ""
echo "=== Image Updater Installed ==="
echo ""
echo "⚠️  NEXT STEPS:"
echo "1. Cập nhật secret GAR credentials:"
echo "   kubectl -n argocd-image-updater create secret docker-registry gar-credentials \\"
echo "     --docker-server=asia-southeast1-docker.pkg.dev \\"
echo "     --docker-username=_json_key \\"
echo "     --docker-password=\"\$(cat /path/to/gcp-sa-key.json)\" \\"
echo "     --dry-run=client -o yaml | kubectl apply -f -"
echo ""
echo "2. Cấu hình Git write-back credentials cho Image Updater:"
echo "   kubectl -n argocd-image-updater create secret generic git-creds \\"
echo "     --from-literal=username=hoanganhnth \\"
echo "     --from-literal=password=<GITHUB_PAT>"
echo ""
echo "3. Thêm annotation vào ArgoCD Application (xem annotations.example.yaml)"
echo ""
echo "4. Kiểm tra logs:"
echo "   kubectl -n argocd-image-updater logs -l app.kubernetes.io/name=argocd-image-updater -f"
