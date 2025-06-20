# singleMachineCashierUI

A fully dockerized Point of Sale (POS) system consisting of:

* **🖥️ Flutter App** (Desktop POS Client)
*  Flutter package for Authentication
* **👥 Auth Service** (Node.js / JWT)
* **🛍️ POS Service** (Node.js / Products, Categories, Orders)
* **📄 Invoicing Service** (Node.js / Invoices & Printing, supporting both **TSE in Germany** and **ZATCA e-invoicing in Saudi Arabia**, configured via `.env`)

All services use a **single MongoDB database**.

## ⚡️ Architecture Diagram

```
[ Flutter App ]
       |
       v
[ Auth Service ] ---> [ MongoDB ]
       |
       v
[ POS Service ] ---> [ MongoDB ]
       |
       v
[ Invoicing Service ] ---> [ MongoDB ]
```

## ✅ Repos

* **Auth Service:** [Authentication Service](https://github.com/aymanElshayeb/authentication-module-node)
* **POS Service:** [POS node service](https://github.com/aymanElshayeb/pos-node)
* **Invoicing Service:** [Invoicing Service](https://github.com/aymanElshayeb/invoicing-node)
* **Flutter App:** (This repo)
* **Flutter Package:** [Auth Package](https://github.com/aymanElshayeb/authentication-package)

## ⚡️ Prerequisites

* 🐳 [Docker & Docker Compose](https://docs.docker.com/compose/install/)
* 💻 [Node.js & NPM](https://nodejs.org/)
* 📱 [Flutter](https://docs.flutter.dev/get-started/install)

## ⚡️ Setup Instructions

1️⃣ **Clone All Repos**

```bash
git clone https://github.com/aymanElshayeb/authentication-module-node.git
git clone https://github.com/aymanElshayeb/pos-node.git
git clone https://github.com/aymanElshayeb/invoicing-node.git
git clone https://github.com/aymanElshayeb/authentication-package.git
```


2️⃣ **Final Directory Layout**

```
flutter_app/
├─ docker-compose.yml
├─ auth_service/
├─ pos_service/
├─ invoicing_service/
├─ flutter_auth_package/
```

3️⃣ **Build Services with Docker**

```bash
docker compose up --build
```

4️⃣ **Run Flutter App**

```bash
cd flutter_app
flutter pub get
flutter run
```

## ⚡️ Ports

| Service           | Port                          |
| ----------------- | ----------------------------- |
| MongoDB           | 27017                         |
| Auth Service      | 3005                          |
| POS Service       | 3003                          |
| Invoicing Service | 3006                          |
| Flutter App       | As configured (default 56821) |

