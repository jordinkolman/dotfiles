# ⚙️ System Configuration & Dotfiles


A modular, version-controlled Linux development environment tailored for backend engineering and systems architecture. 

I treat my workstation configuration as code. This repository uses **GNU Stow** to manage symlinks, keeping configurations isolated by package while maintaining a clean, reproducible setup across machines.

## 🛠️ Core Stack
| Category | Tool | Purpose |
| :--- | :--- | :--- |
| **Host Terminal** | Alacritty (Windows) | GPU-accelerated terminal host rendering the WSL instance |
| **Guest OS** | WSL (Ubuntu) | Native Linux environment on Windows hardware |
| **Package Management** | GNU Stow | Symlink farm manager for modular Linux configuration |
| **Shell / Multiplexer** | Bash + Tmux | Customized shell environment and pane management |
| **Languages & Tooling**| Go, Docker | Pre-configured environment paths and container engine |

## 📂 Structure
This repository is structured around Stow "packages." Each directory mirrors the structure of the `$HOME` directory.
```text
.
├── bash/               # Bash profile, aliases, and environment variables
├── git/                # Global ignores and merge strategies
├── tmux/               # TPM and window/pane configurations
├── .gitignore          # Keeps secrets and local caches out of version control
└── README.md
```

*Note: The Alacritty configuration (`alacritty.toml`) is managed natively on the Windows host filesystem and is not tracked in this WSL-specific repository.*

## 🚀 Installation & Bootstrap
### 1. Prerequisites
Ensure `git` and `stow` are installed on the target machine:
```bash
sudo apt update && sudo apt install git stow -y
```

### 2. Clone and Link
Clone the repository to your home directory and use Stow to symlink the configurations:
```bash
# Clone into the home directory
git clone [https://github.com/](https://github.com/)[your-github-username]/dotfiles.git ~/dotfiles
cd ~/dotfiles
# Deploy packages using Stow
stow bash git tmux
```

### 3. Install Tmux Plugins
After linking, install the Tmux Plugin Manager (TPM) and load the plugins:
```bash
git clone [https://github.com/tmux-plugins/tpm](https://github.com/tmux-plugins/tpm) ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
# Inside tmux, press `Ctrl-Space` + `I` to install plugins

```
## 🔒 Security & Secrets Management
This repository contains **no sensitive information**. 
All API keys, SSH keys, database credentials, and personal Git configurations are explicitly excluded via `.gitignore`. Environment-specific secrets are sourced dynamically via a local `~/.bash_local` file and a `~/.gitconfig.local` file, neither of which are tracked in version control.
