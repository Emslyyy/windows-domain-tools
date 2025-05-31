# 🖥️ Windows Domain Tools

A set of automation scripts to assist with domain join, unjoin, and user/admin verification on Windows 10/11 machines. Ideal for sysadmins managing Active Directory environments.

## 📂 Included Scripts

### 🔐 `JoinDomainAddLocalAdmin.cmd`
Joins a Windows machine to an Active Directory domain and adds a specified domain user to the local **Administrators** group.

**Features:**
- Prompts for domain FQDN, NetBIOS name, domain admin username, and target user.
- Uses PowerShell to join the domain with secure credential prompt.
- Verifies user was added to local Administrators group.
- Reboots the machine after success.

---

### 🧹 `UnjoinDomainRemoveAdmins.cmd`
Removes a computer from the domain and deletes specified domain users from the local **Administrators** group.

**Features:**
- Prompts for domain name and users to remove.
- Removes machine from the domain (joins to workgroup instead).
- Cleans up domain accounts from the local admin group.
- Reboots machine for changes to apply.

---

### 🛡️ `VerifyDomainAndAdmin.cmd`
Checks if the machine is joined to a specific domain and verifies if a domain user is in the local **Administrators** group.

**Features:**
- Asks for domain NetBIOS name and username.
- Confirms current domain membership.
- Checks if the user is in the local Administrators group.
- Optionally verify multiple users in a single session.

---

## ⚠️ Requirements

- Run scripts as **Administrator**
- Windows 10 or 11
- Domain environment with proper permissions
- PowerShell enabled (default in modern Windows)

---

## 🚀 Usage

1. Right-click a script and choose **Run as Administrator**.
2. Follow on-screen prompts.
3. For domain join/unjoin, be ready to enter credentials in a secure popup.

---

## 📘 License

MIT License. Use freely, modify, and share — but no warranty is provided.

---

## 🙋‍♂️ Author

Created by [Emslyyy](https://github.com/Emslyyy) — built for internal automation needs and shared for the community.
