# Linux User Management Script 🔐

![Bash](https://img.shields.io/badge/-Bash-4EAA25?logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/-Linux-FCC624?logo=linux&logoColor=black)
![Open Source](https://img.shields.io/badge/-Open_Source-3DA639?logo=opensourceinitiative&logoColor=white)

Automate user provisioning, access control, and security compliance on Linux systems with this powerful Bash script.

GitHub: [github.com/seshadricloud/user_management](https://github.com/seshadricloud/user_management)  
Demo: [![Try in Replit](https://img.shields.io/badge/Try_in-Replit-%2346a2f1)](https://replit.com/new/linux)

## 🌟 Features

- **User Lifecycle Management** (Create/Delete/Lock/Unlock)
- **Password Policy Enforcement** (Complexity, Aging)
- **Group & Sudo Privilege Management**
- **SSH Key Configuration**
- **Detailed Activity Logging**

mermaid
flowchart TD
    A[Interactive Menu] --> B[Create User]
    A --> C[Security Actions]
    B --> D[Set Password]
    C --> E[Lock/Unlock]

## 🚀 Quick Start

bash
# Clone repository
git clone https://github.com/seshadricloud/user_management.git
cd user_management

# Make executable and run
chmod +x user_management.sh
sudo ./user_management.sh
```

## 📖 Documentation

### Usage Examples
| Scenario | Command |
|----------|---------|
| Create developer with sudo | `1 → dev → P@ssw0rd! → y → sudo → y → n` |
| Lock inactive account | `5 → olduser` |
| List all users | `3` |

### Security Features
- 🔒 Password complexity validation (12+ chars, mixed case)
- 📜 Audit logging to `/var/log/user_management.log`
- ⏳ Automatic password expiration (90 days)

## 💼 Professional Use Cases
- **DevOps Teams**: Automate service account provisioning
- **Cloud Engineers**: Secure VM access management
- **SysAdmins**: Replace manual user management workflows

## 🤝 Contributing
Found a bug? Want to improve the script?
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📜 License
MIT License - See [LICENSE](LICENSE) for details

---
