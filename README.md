# automate_packages_integration

Welcome to **automate_packages_integration**! This project allows users to add Flutter packages to their projects and automatically configure them for Android, iOS, and Web platforms. With this app, users can easily integrate packages such as Google Maps, Firebase, and others by adding the required dependencies and making the necessary configurations.

---

## Features

- Add dependencies for Flutter packages to your project.
- Automatically configure Android, iOS, and Web platforms for the added packages.
- Supports platforms: Windows, macOS, and Linux (Web is not supported).
- Example: Adding and configuring Google Maps with API key integration for all platforms.

---

## Prerequisites

Make sure you have **Flutter** installed on your system. If not, follow the steps below:

--

## 🤝 Contribute

We welcome contributions from the community! Click below to get started:

| Contribution | Description |
|--------------|-------------|
| [📜 Guidelines](./CONTRIBUTING.md) | Follow our contributing guidelines. |
| [🐛 Report a Bug](.github/ISSUE_TEMPLATE/bug_report.md) | Found a bug? Report it here. |
| [✨ Request a Feature](.github/ISSUE_TEMPLATE/feature_request.md) | Have an idea? Let us know! |
| [📥 Pull Request Template](./PULL_REQUEST_TEMPLATE.md) | Learn how to submit a great PR. |

---

## 📁 CI/CD

This project uses GitHub Actions for continuous integration:

- **Workflow file**: [`flutter_ci.yml`](.github/workflows/flutter_ci.yml)

### 1. Install Flutter

- **Windows:** [Flutter installation for Windows](https://flutter.dev/docs/get-started/install/windows)
- **macOS:** [Flutter installation for macOS](https://flutter.dev/docs/get-started/install/macos)
- **Linux:** [Flutter installation for Linux](https://flutter.dev/docs/get-started/install/linux)

### 2. Install Dependencies

After installing Flutter, run the following command in your project directory to install the necessary dependencies:

```bash
flutter pub get
