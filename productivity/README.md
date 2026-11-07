# 📄 Productivity Stacks (`productivity/`)

This directory contains standalone, dedicated deployments of document indexing and PDF manipulation applications mapped to dedicated storage pool volumes (`/mnt/storagepool/`).

---

## 📂 Subdirectory Overview

| Directory | Stack | Port | Purpose |
| :--- | :--- | :--- | :--- |
| [`paperless/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/productivity/paperless/README.md) | **Paperless-ngx (Standalone)** | `8010` | Fully self-contained stack with bundled Redis 7 and PostgreSQL 16 |
| [`stirlingpdf/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/productivity/stirlingpdf/README.md) | **Stirling-PDF (Fat Image)** | `8082` | Full-featured PDF toolset with OCR language packages included |

---

## 💡 Standalone vs. Utility Tier

- Use **[`utility/docker-compose.yml`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/utility/README.md)** if you prefer sharing the central PostgreSQL 18 and Redis 8 instances in `data/`.
- Use the stacks in **`productivity/`** if you prefer complete container and storage isolation with dedicated databases mounted to `/mnt/storagepool/`.

