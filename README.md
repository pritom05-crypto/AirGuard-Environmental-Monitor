# 🌬️ AirGuard Environmental Monitor

<p align="center">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="85" alt="Flutter"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg" width="85" alt="Firebase"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="85" alt="Dart"/>
</p>

<h2 align="center">Smart Environmental Monitoring System</h2>

<p align="center">
  <b>Monitor. Analyze. Protect.</b>
</p>

<p align="center">
  An IoT-powered environmental monitoring platform built with
  <b>Flutter, Firebase, ESP32 and environmental sensors.</b>
</p>

<p align="center">
  <a href="https://pritom05-crypto.github.io/AirGuard-Environmental-Monitor/">
    <img src="https://img.shields.io/badge/🌐%20Live%20Demo-AirGuard-00A86B?style=for-the-badge" alt="Live Demo"/>
  </a>
  <a href="https://github.com/pritom05-crypto/AirGuard-Environmental-Monitor">
    <img src="https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github" alt="GitHub"/>
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.47.0-02569B?logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.13.0-0175C2?logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/ESP32-IoT-E7352C?logo=espressif&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitHub%20Pages-Live-222222?logo=github"/>
</p>

---

## 🌐 Live Application

### 🚀 Try AirGuard Online

<p align="center">

<a href="https://pritom05-crypto.github.io/AirGuard-Environmental-Monitor/">
  <img src="https://img.shields.io/badge/OPEN%20LIVE%20APP-🌐-brightgreen?style=for-the-badge" alt="Open Live App"/>
</a>

</p>

**Live URL:**
https://pritom05-crypto.github.io/AirGuard-Environmental-Monitor/

---

# 📸 Web Application Preview

> Screenshots of the AirGuard web dashboard will be added here.

### 🖥️ Dashboard

<p align="center">
  <img src="screenshots/dashboard.png" width="90%" alt="AirGuard Dashboard"/>
</p>

### 📊 Monitoring Interface

<p align="center">
  <img src="screenshots/monitoring.png" width="90%" alt="AirGuard Monitoring"/>
</p>

### 📱 Responsive View

<p align="center">
  <img src="screenshots/responsive.png" width="70%" alt="AirGuard Responsive Interface"/>
</p>

> **To add your screenshots:** create a folder named `screenshots` in the project root and place your images inside it using the names above.

---

# 🌱 About AirGuard

**AirGuard Environmental Monitor** is a smart environmental monitoring platform designed to provide real-time visibility into environmental and machine-related conditions.

The system combines **IoT hardware, environmental sensors, cloud infrastructure, and a modern Flutter dashboard** into a single monitoring solution.

Sensor information can be collected through an **ESP32-based IoT system**, transmitted over Wi-Fi, stored in **Firebase Cloud Firestore**, and visualized through the Flutter application.

The goal is simple:

> **Turn raw environmental data into useful, real-time information.**

---

# 🎯 Project Objectives

AirGuard is designed to:

* 🌡️ Monitor environmental conditions
* 🌫️ Track air-quality-related data
* 💧 Monitor humidity
* 🏭 Observe machine/environment status
* 📡 Collect IoT sensor data
* ☁️ Store data in the cloud
* 📊 Present data through an intuitive dashboard
* ⚡ Provide real-time monitoring
* 🚨 Help identify abnormal environmental conditions

---

# ✨ Key Features

### 🌡️ Environmental Monitoring

Monitor important environmental parameters through connected sensors.

* Temperature
* Humidity
* Air quality
* Gas/sensor readings
* Other supported environmental parameters

---

### 📡 IoT Data Collection

The system can use an **ESP32** as the IoT controller.

```text
Sensor
   ↓
ESP32
   ↓
Wi-Fi
   ↓
Firebase
```

This allows physical sensor data to reach the cloud and become available to the monitoring application.

---

### ☁️ Firebase Cloud Integration

Firebase Cloud Firestore provides cloud-based data storage and synchronization.

The application can retrieve monitoring information from Firestore and display the latest available values.

---

### 📊 Smart Dashboard

The Flutter dashboard is designed to provide a quick overview of the monitored environment.

Possible dashboard information includes:

```text
┌──────────────────────────────────────────┐
│             AIRGUARD MONITOR             │
├──────────────────────────────────────────┤
│                                          │
│   🌡️ Temperature       28°C              │
│   💧 Humidity          65%               │
│   🌫️ Air Quality       Normal             │
│                                          │
│   🟢 System Status     Online             │
│                                          │
└──────────────────────────────────────────┘
```

---

### ⚡ Real-Time Monitoring

When new data becomes available through the connected backend, the dashboard can update the displayed information without requiring a manual page refresh.

---

### 🌐 Web Application

AirGuard is available as a Flutter Web application and is deployed through **GitHub Pages**.

---

# 🏗️ System Architecture

```text
                 ┌──────────────────────┐
                 │   Environmental      │
                 │      Sensors         │
                 │                      │
                 │ 🌡️ Temperature       │
                 │ 💧 Humidity          │
                 │ 🌫️ Air Quality       │
                 │ ⚙️ Other Sensors     │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │        ESP32         │
                 │                      │
                 │ Sensor Reading       │
                 │ Data Processing      │
                 │ Wi-Fi Communication  │
                 └──────────┬───────────┘
                            │
                            │ Wi-Fi
                            ▼
                 ┌──────────────────────┐
                 │       Firebase       │
                 │      Firestore       │
                 │                      │
                 │ Cloud Data           │
                 │ Sensor Records       │
                 │ Monitoring Data      │
                 └──────────┬───────────┘
                            │
                            │ Real-Time Data
                            ▼
                 ┌──────────────────────┐
                 │      Flutter         │
                 │      Dashboard       │
                 │                      │
                 │ 📊 Analytics         │
                 │ 🌡️ Sensors           │
                 │ 🚨 Status            │
                 │ 📱 Responsive UI     │
                 └──────────────────────┘
```

---

# 🔄 Data Flow

```text
Environmental Sensor
        │
        ▼
      ESP32
        │
        ▼
      Wi-Fi
        │
        ▼
Firebase Firestore
        │
        ▼
 Flutter Application
        │
        ▼
 Monitoring Dashboard
        │
        ▼
       User
```

### How It Works

1. Sensors collect environmental information.
2. ESP32 reads the sensor values.
3. The ESP32 communicates through Wi-Fi.
4. Data is transmitted to the cloud backend.
5. Firebase Firestore stores the monitoring information.
6. Flutter retrieves the data.
7. AirGuard displays the information through the dashboard.

---

# 🔧 Hardware

| Component                 | Purpose                                |
| ------------------------- | -------------------------------------- |
| 🔴 **ESP32**              | IoT controller and Wi-Fi communication |
| 🌡️ **DHT11**             | Temperature & humidity monitoring      |
| 🌫️ **MQ135**             | Air quality / gas monitoring           |
| 🔌 **Power Supply**       | Provides power to the IoT system       |
| 🔧 **Additional Sensors** | Extend monitoring capabilities         |

---

# 💻 Technology Stack

## 🎨 Frontend

<p>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="55" alt="Flutter"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="55" alt="Dart"/>
</p>

* Flutter
* Dart
* Material Design
* Responsive UI
* Flutter Web

---

## ☁️ Backend & Cloud

<p>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg" width="55" alt="Firebase"/>
</p>

* Firebase
* Cloud Firestore
* Real-time data synchronization

---

## 🤖 IoT

* ESP32
* Wi-Fi
* DHT11
* MQ135
* Environmental sensors

---

## 🛠️ Development Tools

* Visual Studio Code
* Arduino IDE
* Git
* GitHub
* GitHub Actions

---

# 📂 Project Structure

```text
AirGuard-Environmental-Monitor/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── android/
├── ios/
├── web/
├── windows/
│
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   │
│   ├── models/
│   │
│   ├── screens/
│   │
│   ├── services/
│   │
│   └── widgets/
│
├── assets/
│
├── screenshots/
│   ├── dashboard.png
│   ├── monitoring.png
│   └── responsive.png
│
├── test/
│
├── pubspec.yaml
├── README.md
└── .gitignore
```

---

# ☁️ Firebase Architecture

A possible Firestore structure:

```text
Firestore
│
├── machines
│   │
│   ├── machine_01
│   │   ├── name
│   │   ├── status
│   │   └── updatedAt
│   │
│   └── machine_02
│       ├── name
│       ├── status
│       └── updatedAt
│
└── sensors
    │
    ├── temperature
    ├── humidity
    └── airQuality
```

The exact database structure may evolve as the project develops.

---

# 🚀 Getting Started

## Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Git
* Visual Studio Code
* Android Studio / Android SDK
* Firebase project

Check your Flutter installation:

```bash
flutter doctor
```

---

## 1️⃣ Clone the Repository

```bash
git clone https://github.com/pritom05-crypto/AirGuard-Environmental-Monitor.git
```

Enter the project directory:

```bash
cd AirGuard-Environmental-Monitor
```

---

## 2️⃣ Install Dependencies

```bash
flutter pub get
```

---

## 3️⃣ Run the Application

### Chrome / Web

```bash
flutter run -d chrome
```

### Android

```bash
flutter run
```

---

# 🌐 Build for Web

Create a production web build:

```bash
flutter build web --release
```

The generated files will be available at:

```text
build/web/
```

---

# 🚀 GitHub Pages Deployment

AirGuard uses **GitHub Actions** to automatically deploy the Flutter Web application.

The deployment workflow is located at:

```text
.github/workflows/deploy.yml
```

Whenever changes are pushed to the `main` branch:

```text
git push
   ↓
GitHub Actions
   ↓
Flutter Web Build
   ↓
GitHub Pages
   ↓
🌐 Live Application
```

### Manual deployment trigger

The workflow can also be triggered manually from:

**GitHub → Actions → Deploy AirGuard to GitHub Pages**

---

# 📱 Android Build

### Debug APK

```bash
flutter build apk
```

### Release APK

```bash
flutter build apk --release
```

### Google Play App Bundle

```bash
flutter build appbundle
```

---

# 🔐 Security

Security is important for any cloud-connected IoT application.

Never commit sensitive information such as:

* ❌ Private keys
* ❌ Passwords
* ❌ Service account credentials
* ❌ Private API secrets
* ❌ Authentication tokens

Firebase Security Rules should be configured appropriately before production deployment.

---

# 🧪 Project Status

| Feature                  | Status        |
| ------------------------ | ------------- |
| Flutter Application      | ✅ Completed   |
| Responsive Web Interface | ✅ Completed   |
| Firebase Integration     | ✅ Completed   |
| Cloud Firestore          | ✅ Integrated  |
| GitHub Repository        | ✅ Completed   |
| GitHub Actions           | ✅ Configured  |
| GitHub Pages             | ✅ Live        |
| Environmental Monitoring | 🔄 Developing |
| ESP32 Integration        | 🔄 Developing |
| Sensor Integration       | 🔄 Developing |
| Historical Analytics     | 🚧 Planned    |
| Notifications            | 🚧 Planned    |

---

# 🛣️ Future Improvements

AirGuard can be extended with:

* 📈 Historical sensor-data visualization
* 🚨 Automatic abnormal-condition detection
* 🔔 Push notifications
* 📊 Advanced analytics
* 🏭 Multi-machine monitoring
* 👤 User authentication
* 🔐 Role-based access control
* 📱 Improved mobile experience
* 🌐 Advanced web dashboard
* 📡 Additional environmental sensors
* 🧠 Predictive maintenance
* 🤖 AI-based anomaly detection

---

# 👥 Contributors

This project is developed collaboratively.

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/pritom05-crypto">
        <img src="https://github.com/pritom05-crypto.png" width="100px" alt="Pritom Kumar Bhowmik"/>
        <br />
        <sub><b>Pritom Kumar Bhowmik</b></sub>
      </a>
      <br />
      <sub>Developer</sub>
    </td>
    <td align="center">
      <a href="https://github.com/Rupu-s">
        <img src="https://github.com/Rupu-s.png" width="100px" alt="Rupu"/>
        <br />
        <sub><b>Rupu</b></sub>
      </a>
      <br />
      <sub>Developer</sub>
    </td>
  </tr>
</table>

---

# 📜 License

This project is developed for **educational, research, and demonstration purposes**.

---

# ⭐ Support AirGuard

If you like this project, consider giving the repository a ⭐.

<p align="center">

<a href="https://github.com/pritom05-crypto/AirGuard-Environmental-Monitor">
  <img src="https://img.shields.io/github/stars/pritom05-crypto/AirGuard-Environmental-Monitor?style=for-the-badge&logo=github" alt="GitHub Stars"/>
</a>

</p>

---

<p align="center">

# 🌬️ AirGuard

### Smart Monitoring. Real-Time Insights. Safer Environment.

**Built with Flutter • Firebase • ESP32 • IoT**

<br />

<a href="https://pritom05-crypto.github.io/AirGuard-Environmental-Monitor/">
  🌐 <b>Visit Live Application</b>
</a>

</p>
