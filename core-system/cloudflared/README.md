# 🌐 Cloudflare Tunnel (`cloudflared`)

<p align="center">
  <img src="https://img.shields.io/badge/Cloudflare_Tunnel-F38020?style=for-the-badge&logo=cloudflare&logoColor=white" alt="Cloudflare" />
</p>

Provides an outbound-only encrypted tunnel from your local network directly into Cloudflare's global edge network. This allows publishing internal web services securely without opening router ports or exposing your public IP.

---

## ⚙️ Configuration

The container requires a Cloudflare Tunnel token generated from the Cloudflare Zero Trust Dashboard (**Networks** &rarr; **Tunnels**):

Create a `.env` file in this directory:
```ini
TUNNEL_TOKEN=eyJhIjoiYmMy...your_cloudflare_tunnel_token_here...
```

### DNS Resolver Fix
The compose file preconfigures reliable public upstream DNS resolvers (`1.1.1.1`, `1.0.0.1`, `8.8.8.8`) to prevent DNS resolution failures during system boot or local resolver outages.

---

## 🚀 Deployment

```bash
cd core-system/cloudflared
docker compose up -d
```

### Viewing Tunnel Status
```bash
docker logs -f cloudflared
```
A successful connection will show: `Connection registered with Cloudflare edge`.

