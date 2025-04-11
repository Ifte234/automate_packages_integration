# Contributing to [Your Project Name]

Thank you for your interest in contributing! Follow these simple steps to get started and help improve the project.

---

## Getting Started

1. **Fork and Clone:**
   - Fork the repository on GitHub by clicking the **Fork** button.
   - Clone your fork locally:
     ```bash
     git clone https://github.com/<your-username>/<repository-name>.git
     cd <repository-name>
     ```

2. **Create a Branch:**
   - Create a new branch for your changes using a descriptive name:
     ```bash
     git checkout -b your-feature-name
     ```

---

## Making Changes

- **Code & Naming Guidelines:**
  - Write clean and simple code.
  - Use lowercase with underscores for file names (e.g., `user_profile.dart`).
  - Use PascalCase for class names (e.g., `UserProfile`).
  - Use camelCase for variables and function names (e.g., `getUserData`).

- **Commit Your Changes:**
  - Make regular commits with clear and meaningful messages:
    ```bash
    git add .
    git commit -m "Add new feature for [brief description]"
    ```

---

## Submitting a Pull Request

1. **Push Your Branch:**
   - Push your branch to your fork:
     ```bash
     git push origin your-feature-name
     ```

2. **Create a Pull Request:**
   - Open your fork on GitHub.
   - Click on **Compare & pull request** and fill in the details.
   - Submit the PR for review.

---

## Running the App Locally

1. **Install Flutter:**
   - Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) for your platform.

2. **Get Dependencies:**
   - Run the following command in your project directory:
     ```bash
     flutter pub get
     ```

3. **Environment Setup:**
   - This project uses `.env` files for environment-specific configuration.
   - These files are listed in `.gitignore` and **should not be committed**.
   - You will need to manually create them:

     ```bash
     mkdir -p assets
     touch assets/.env.development
     touch assets/.env.production
     ```

   - Fill them with the necessary environment variables as needed. Contact a maintainer if you need help with the values.

4. **Run the App:**
   - Launch an emulator or connect a device, then run:
     ```bash
     flutter run
     ```

5. **Run Tests (Optional):**
   - If you make changes that affect functionality, you can run tests:
     ```bash
     flutter test
     ```

---

Thank you for contributing! If you have any questions, feel free to open an issue for help.
