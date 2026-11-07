# 📄 Standalone Stirling-PDF (`productivity/stirlingpdf`)

<p align="center">
  <img src="https://img.shields.io/badge/Stirling--PDF-latest--fat-FF0000?style=for-the-badge&logo=adobeacrobatreader&logoColor=white" alt="Stirling-PDF" />
</p>

A dedicated instance of [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) using the `latest-fat` container image, which includes complete OCR language packs, image conversion dependencies, and libreoffice pre-installed.

---

## ⚙️ Configuration & Port

- **Host Port**: `8082` (mapped to internal container port `8080` to prevent port collisions)
- **Tesseract OCR**: Configured for English (`LANGS=en_GB`)
- **Volumes**:
  - `/mnt/storagepool/media/config/stirling-pdf/customFiles:/customFiles/`
  - `/mnt/storagepool/config/stirling-pdf/trainingData:/usr/share/tessdata`
  - `/mnt/storagepool/config/stirling-pdf/extraConfigs:/configs`

---

## 🚀 Deployment

```bash
cd productivity/stirlingpdf
docker compose up -d
```
Access the application at `http://<HOST_IP>:8082`.

