# GeoNode OGC Load Testing Suite  
**Stress tests for WFS, WMS, CSW and Upload endpoints using Apache JMeter in Docker**

![Docker](https://img.shields.io/badge/Docker-✓-2496ED?logo=docker&logoColor=white)  
![Apache JMeter](https://img.shields.io/badge/Apache%20JMeter-5.6.3-red?logo=apache)  
![Shell Scripts](https://img.shields.io/badge/Shell%20Scripts-Automation-4EAA25?logo=gnu-bash&logoColor=white)  
![Status](https://img.shields.io/badge/Status-Ready-brightgreen)  
![License](https://img.shields.io/badge/License-MIT-blue)

---

## 📌 Overview

This repository provides a **complete and automated environment** to stress-test **GeoNode OGC services**:

- **WFS** – Reads (GetFeature)  
- **WMS** – Reads (GetMap)  
- **CSW** – Metadata search  
- **Uploads** – GeoTIFF, Shapefile, Zip datasets  
- **Basic Auth support** for secured endpoints  
- **Automated reports** (HTML + CSV)  
- **Reusable and parameterized JMeter test plans**

Everything runs **inside Docker**, orchestrated via **docker-compose**.  
You only need to edit an `.env` file and run:

```

docker compose up --build

```

---

## 🧱 Repository Structure

```

.
├── docker-compose.yml
├── .env
├── jmeter/
│   ├── Dockerfile
│   ├── test-plans/
│   │   ├── wfs_read.jmx
│   │   ├── wms_read.jmx
│   │   ├── csw_search.jmx
│   │   └── upload_dataset.jmx
│   ├── scripts/
│   │   ├── run-tests.sh
│   │   └── gen-report.sh
│   ├── reports/
│   └── data/
│       └── sample.zip


````

---

## ⚙️ Requirements

- Ubuntu 24.04 VM  
- Docker  
- Docker Compose V2  
- GeoNode instance reachable from the VM  

---

## 🔧 Configuration (ENV file)

Create a `.env` with your environment parameters:

```env
GEONODE_BASE_URL=https://ide-hm.geobases.es.gov.br
GEONODE_USERNAME=admin
GEONODE_PASSWORD=senha123
THREADS=50
RAMPUP=20
DURATION=120
UPLOAD_FILE=/data/input/dataset.zip
````

You can mount as many test files as you want under:

```
./jmeter/data/
```

---

## 🐳 Starting JMeter via Docker Compose

The stack includes:

* JMeter CLI (inside a container)
* Volume persistence for test plans and reports
* Automated run + report generation

Start:

```
docker compose up --build
```

Run again (without rebuilding):

```
docker compose up
```

Stop:

```
docker compose down
```

---

## 🚀 Running Tests Manually

Inside the container:

```
docker exec -it jmeter jmeter -n -t /test-plans/wfs_read.jmx -l /reports/wfs.jtl
```

Or run all tests automatically:

```
docker exec -it jmeter /scripts/run-tests.sh
```

---

## 📊 Reports

After every execution, an automated HTML report is generated:

```
docker exec -it jmeter /scripts/gen-report.sh
```

Reports will be available in:

```
jmeter/reports/<timestamp>/
```

Generated files include:

* `index.html` (interactive performance dashboard)
* `summary.csv`
* `latency.csv`
* `errors.csv`

---

## 📁 Scripts Included

### **run-tests.sh**

Runs all `.jmx` test plans sequentially using environment variables.

### **gen-report.sh**

Generates standardized JMeter HTML reports for each test execution.

---

## 🛠️ Customizing Test Plans

Every `.jmx` file includes variables:

* `${BASE_URL}`
* `${USERNAME}`
* `${PASSWORD}`
* `${THREADS}`
* `${RAMPUP}`
* `${DURATION}`
* `${UPLOAD_FILE}` (only for upload)

You can edit test plans directly in JMeter GUI if needed.

---

## 🔐 Basic Auth Usage

Basic Auth is already integrated in all tests through:

* HTTP Authorization Manager
* Variables: `${USERNAME}` and `${PASSWORD}`

No extra configuration required unless your GeoNode uses OAuth2 or SSO.

---

---

## 📊 Listing JMeter Reports on the Web (HTTPS)

This project includes an **Nginx + Certbot** setup to publish JMeter HTML reports over **HTTPS**, protected by **Basic Authentication**.

Once configured, reports will be available at:


---

### 🚀 Initial Setup (one-time)

Run the following steps **in order** on the host machine:

#### 1️⃣ Create Basic Authentication automatically

This step generates the `htpasswd` file if it does not already exist.

```bash
./scripts/init-auth.sh
````

---

#### 2️⃣ Start Nginx (required for the HTTP challenge)

Nginx must be running to allow Let's Encrypt to validate the domain.

```bash
docker compose up -d nginx
```

---

#### 3️⃣ Generate the HTTPS certificate automatically

This step requests a Let's Encrypt certificate using Certbot.

```bash
./scripts/init-certbot.sh
```

---

#### 4️⃣ Restart Nginx with HTTPS enabled

After the certificate is issued, restart Nginx to enable TLS.

```bash
docker compose restart nginx
```

---

### ✅ Result

* 🔒 HTTPS enabled via Let's Encrypt
* 🔐 Basic Authentication enabled
* 📂 Automatic directory listing of JMeter HTML reports

Access:

```
https://DOMAIN/reports/
```

---

### 🔁 Certificate Renewal

Certificates are renewed automatically.
To renew manually:

```bash
docker compose run --rm certbot renew && docker compose restart nginx
```

---

---

## 📦 Docker Compose File

The compose file:

* builds its own image (`jmeter-extended`)
* mounts test plans, scripts, reports
* loads `.env` automatically
* runs automation scripts

---

## 🤝 Contributing

Pull requests are welcome — especially for:

* new OGC test plans
* Kubernetes deployment
* CI/CD automation

---

## 📜 License

MIT License – free to use and modify.

---
