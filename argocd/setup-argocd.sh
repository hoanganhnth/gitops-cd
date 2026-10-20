#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: setup-argocd.sh
# Purpose: Bootstrap ArgoCD on Google Kubernetes Engine (GKE)
# ==============================================================================

echo "================================================="
echo "   🚀 BẮT ĐẦU CÀI ĐẶT ARGOCD LÊN CỤM GKE"
echo "================================================="

# 1. Tạo namespace argocd
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# 2. Cài đặt ArgoCD bản stable mới nhất
echo "📦 Đang cài đặt ArgoCD manifests..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Đợi các pods của ArgoCD khởi động
echo "⏳ Đang chờ ArgoCD components sẵn sàng..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd || true

# 4. Expose ArgoCD Server qua LoadBalancer (hoặc dùng Ingress nếu có domain)
echo "🌐 Đổi service type sang LoadBalancer để truy cập UI..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# 5. Khởi tạo Root Application (App-of-Apps)
echo "🌱 Đang nạp Root App-of-Apps..."
kubectl apply -f "$(dirname "$0")/root-app.yaml"

# 6. Lấy mật khẩu đăng nhập ban đầu
INITIAL_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 --decode || echo "")

echo ""
echo "================================================="
echo "   🎉 ARGOCD ĐÃ ĐƯỢC CÀI ĐẶT THÀNH CÔNG!"
echo "================================================="
echo "Tài khoản admin mặc định:"
echo "Username: admin"
if [[ -n "$INITIAL_PASSWORD" ]]; then
  echo "Password: $INITIAL_PASSWORD"
else
  echo "Lệnh lấy password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
fi
echo ""
echo "Xem IP công khai của ArgoCD UI:"
echo "kubectl get svc argocd-server -n argocd"
echo "================================================="
