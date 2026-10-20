# Delivery Platform Infrastructure as Code (Terraform)

Hạ tầng triển khai trên Google Cloud Platform (GCP) bằng Terraform theo chuẩn Enterprise & Cloud Native.

## Cấu trúc Module

```
terraform/
├── main.tf                    # Root orchestration module
├── variables.tf               # Root input variables
├── outputs.tf                 # Root outputs (endpoints, URLs, SA emails)
├── versions.tf                # Provider definitions (Google, Random)
├── terraform.tfvars.example   # Config mẫu (project_id, node counts, machine types)
└── modules/
    ├── vpc/                   # VPC network, Custom subnets, Cloud Router, Cloud NAT
    ├── artifact-registry/     # GCP Artifact Registry Docker repository
    ├── iam/                   # Service Accounts (GKE Nodes, CI/CD GitHub Actions) + Role bindings
    └── gke/                   # GKE Regional Cluster (VPC-native, Workload Identity, Autoscaling node pool)
```

## Các tính năng chính

1. **VPC-Native GKE Cluster**:
   - Tách biệt dải IP Node (`10.10.0.0/20`), Pods (`10.20.0.0/16`), và Services (`10.30.0.0/20`).
   - Private Nodes: Node không có Public IP, kết nối ra internet qua **Cloud NAT**.
2. **Workload Identity**:
   - Cho phép Pods Kubernetes giao tiếp an toàn với GCP API (GCS, KMS, BigQuery...) không cần lưu JSON key trong Secret.
3. **Tiết kiệm chi phí (Hibernation & Spot VMs)**:
   - Hỗ trợ `initial_node_count = 0` và `node_count_min = 0`: khi không sử dụng hoặc hạ tầng ở chế độ chờ, cụm không tiêu tốn tiền node Compute Engine.
   - Hỗ trợ cờ `spot_instances = true` tiết kiệm 60-80% chi phí.
4. **Security & Least Privilege**:
   - Service account riêng biệt cho worker node (`gke-nodes-sa`) chỉ có quyền ghi log, gửi metrics và kéo ảnh từ Artifact Registry.
   - Service account cho GitHub Actions (`delivery-github-actions`) chỉ có quyền đẩy Docker image và deploy GKE.

## Hướng dẫn triển khai

### 1. Chuẩn bị GCP Credentials

```bash
# Đăng nhập GCP SDK
gcloud auth application-default login
gcloud config set project lithe-paratext-506208-s5

# Kích hoạt các API cần thiết (chỉ chạy 1 lần)
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  artifactregistry.googleapis.com \
  iam.googleapis.com
```

### 2. Thiết lập cấu hình Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Chỉnh sửa terraform.tfvars nếu cần thay đổi cấu hình
```

### 3. Init và Apply

```bash
# Khởi tạo Terraform
terraform init

# Xem trước kế hoạch triển khai
terraform plan

# Áp dụng hạ tầng
terraform apply
```

### 4. Kết nối tới GKE Cluster sau khi tạo

```bash
gcloud container clusters get-credentials delivery-cluster \
  --region asia-southeast1 \
  --project lithe-paratext-506208-s5
```
