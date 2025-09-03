# Pass-Manager: A CLI Password Manager

Pass-Manager is a simple yet powerful command-line password manager for Linux. It uses the trusted GnuPG (GPG) to encrypt and store your credentials locally, providing a secure and minimalist solution for managing your data without any hassle.

-----

### ✨ Features

  * **GPG Encryption**: Your data is secured locally using the industry-standard GnuPG, ensuring only you can access it.
  * **Simple & Effective**: A minimal, intuitive command-line interface that gets the job done without any bloat.
  * **Built-in Generator**: Quickly generate strong, random passwords on the fly.
  * **Full Control**: Add, retrieve, list, and delete your credentials with ease.
  * **Pure Bash**: A lightweight script with zero external dependencies, making it fast and reliable.

-----

### 🚀 Getting Started

#### Prerequisites

You must have **GnuPG (GPG)** installed and a GPG key pair set up on your system.

#### 1\. Clone the repository

```bash
git clone https://github.com/ShayanGolmezerji/Pass-Manager.git
cd Pass-Manager
```

#### 2\. Configure Your GPG Key

Open the `pass-manager.sh` file and set the `GPG_RECIPIENT` variable to your GPG user ID.

```bash
# Example:
GPG_RECIPIENT="Shayan Golmezerji (pass) <shayangolmezerji@example.com>"
```

#### 3\. Make the script executable

```bash
chmod +x pass-manager.sh
```

#### 4\. Install as a command

To use `Pass-Manager` from anywhere, move the script to a directory in your `$PATH`, like `/usr/local/bin`. It's a common practice to shorten the command name.

```bash
sudo mv pass-manager.sh /usr/local/bin/pass
```

-----

### 💻 Usage

Once installed, simply run `pass` with a command to manage your passwords.

  * **`pass add`**
      * Adds a new password entry.
  * **`pass get <service-name>`**
      * Retrieves and displays the password for a specific service.
  * **`pass list`**
      * Lists all saved password entries.
  * **`pass delete`**
      * Prompts you to delete an existing entry.
  * **`pass generate`**
      * Generates a secure, random password.
  * **`pass --help`**
      * Displays the help menu.

-----

### 👨‍💻 Author

Made with ❤️ by [Shayan Golmezerji](github.com/shayangolmezerji)
