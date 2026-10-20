# 🚀 Delivery Platform GitOps CD Repository (`gitops-cd`)

Kho chứa cấu hình triển khai tập trung (Centralized Continuous Deployment) cho toàn bộ hệ thống Delivery trên **Google Kubernetes Engine (GKE)** sử dụng **Helm** và **ArgoCD**.

---

## 🏛️ Kiến Trúc Tổng Thể

```
                      [Các Repository Ứng Dụng]
    backend_delivery        delivery_web         delivery_app / shipper_app2
   (Spring Boot micro)     (React + Vite)       (Flutter / React Native)
           │                     │                           │
           │ CI Build Docker     │ CI Build Docker           │ CI Test/Build APK
           ▼                     ▼                           ▼
    Artifact Registry     Artifact Registry           GitHub Artifacts
           │                     │
           └──────────┬──────────┘
                      │ Cập nhật image tag (update-image.sh)
                      ▼
             ┌─────────────────────────────────┐
             │     gitops-cd (Repository này)  │
             │  ├── helm/charts/               │
             │  └── helm/environments/         │
             └────────────────┬────────────────┘
                              │ Webhook / Polling
                              ▼
                     ┌──────────────────┐
                     │  ArgoCD trên GKE │
                     └────────┬─────────┘
                              │ Tự động đồng bộ (Self-heal & Sync)
                              ▼
             ┌─────────────────────────────────┐
             │       GKE Kubernetes Pods       │
             │   (Staging / Production)        │
             └─────────────────────────────────┘
```

---

## 📁 Cấu Trúc Thư Mục

```
.
├── .github/workflows/
│   └── lint-and-validate.yml        # Kiểm tra tính hợp lệ của Helm Charts & YAML
├── argocd/
│   ├── root-app.yaml                # Root Application (Mô hình App-of-Apps)
│   ├── applications/
│   │   ├── staging.yaml             # Khai báo ArgoCD App cho môi trường Staging
│   │   └── production.yaml          # Khai báo ArgoCD App cho môi trường Production
│   ├── setup-argocd.sh              # Script bootstrap ArgoCD lên cụm GKE
│   └── webhook-setup.md             # Hướng dẫn cấu hình Webhook cho deploy tức thì
├── helm/
│   ├── charts/
│   │   ├── microservice/            # Generic reusable chart cho các backend microservice
│   │   └── web-app/                 # Generic reusable chart cho các frontend React app
│   └── environments/
│       ├── staging/
│       │   ├── Chart.yaml           # Umbrella chart Staging
│       │   └── values.yaml          # Tags, replicas & env configs của Staging
│       └── production/
│           ├── Chart.yaml           # Umbrella chart Production
│           └── values.yaml          # Tags, replicas & env configs của Production
└── scripts/
    └── update-image.sh              # Script được CI gọi để tự động cập nhật image tag
```

---

## 🛠️ Hướng Dẫn Kích Hoạt ArgoCD trên GKE

1. Đảm bảo bạn đã kết nối `kubectl` tới cụm GKE:
   ```bash
   gcloud container clusters get-credentials delivery-cluster --zone asia-southeast1-a --project lithe-paratext-506208-s5
   ```

2. Chạy script cài đặt ArgoCD:
   ```bash
   bash argocd/setup-argocd.sh
   ```

3. Lấy IP của ArgoCD UI:
   ```bash
   kubectl get svc argocd-server -n argocd
   ```

4. Cấu hình Webhook theo hướng dẫn tại [`argocd/webhook-setup.md`](argocd/webhook-setup.md) để ArgoCD nhận diện thay đổi ngay lập tức sau khi có commit mới.

---

## 🤖 Cách CI/CD Các Repo Khác Tương Tác Với GitOps

Khi một service (ví dụ `api-gateway` hoặc `delivery-web`) build xong container mới:
CI workflow sẽ clone repo này và chạy:
```bash
./scripts/update-image.sh --service api-gateway --tag <COMMIT_SHA> --env staging --commit
git push origin main
```
ArgoCD sẽ nhận diện commit mới qua Webhook và tự động rolling update pod trên GKE mà không cần cấp quyền truy cập Kubernetes trực tiếp cho repository code!
