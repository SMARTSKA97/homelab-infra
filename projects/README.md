# 🚀 Projects & Development Workloads (`projects/`)

This directory houses self-hosted development environments, internal custom applications, and project-specific infrastructure templates.

---

## 📂 Active Projects

| Project | Tech Stack | Ports | Description |
| :--- | :--- | :--- | :--- |
| [`finplanner-beta/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/projects/finplanner-beta/README.md) | .NET Core 8 + Angular + Redis + PostgreSQL | `5050` (API), `5051` (Web) | Financial management & budget tracking suite with partitioned time-series storage |

---

## 🛠️ Adding New Projects

To add a new project:
1. Create a subdirectory under `projects/<project-name>/`.
2. Add a `docker-compose.yml` declaring its isolated services.
3. If the project needs to communicate with shared resources (like the central PostgreSQL or Nginx Proxy Manager), connect it to the `shared-backend-tier` external network.
4. Add a `README.md` with instructions on required environment variables and run commands.

