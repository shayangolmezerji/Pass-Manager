# Pass-Manager: A CLI Password Manager 🔐

Pass-Manager is a simple yet powerful command-line password manager for Linux. It uses the trusted GnuPG (GPG) to encrypt and store your credentials locally, providing a secure and minimalist solution for managing your data without any hassle.

-----

### ✨ Features

  * **GPG Encryption**: Your data is secured locally using the industry-standard GnuPG, ensuring only you can access it.
  * **Simple & Effective**: A minimal, intuitive command-line interface that gets the job done without any bloat.
  * **Built-in Generator**: Quickly generate strong, random passwords on the fly, now with a wider range of special characters.
  * **Full Control**: Add, retrieve, list, and delete your credentials with ease.
  * **Clipboard Integration**: The `get` command securely copies the password to your clipboard for easy pasting.
  * **Pure Bash**: A lightweight script with zero external dependencies, making it fast and reliable.

-----

### 🚀 Getting Started

#### Prerequisites

You must have **GnuPG (GPG)** installed and a GPG key pair set up on your system. For the clipboard feature to work, you also need to install **`xclip`**.

```bash
# Example for Debian/Ubuntu
sudo apt-get install gpg xclip
```

#### 1\. Clone the repository

```bash
git clone https://github.com/ShayanGolmezerji/Pass-Manager.git
cd Pass-Manager
```

#### 2\. Configure Your GPG Key

Open the `pass-manager.sh` file and set the `GPG_RECIPIENT` variable to your GPG user ID. This must be a key that is present in your keyring. You can find your key ID by running `gpg --list-keys`.

```bash
# Example:
GPG_RECIPIENT="Your Name (Your Key ID) <your-email@example.com>"
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
      * Retrieves the password for a specific service and copies it to your clipboard.
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

Made with ❤️ by [Shayan Golmezerji](https://www.google.com/search?q=https://github.com/shayangolmezerji)
