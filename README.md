# Linux Automation & DevOps Bash Projects

This repository contains three Bash automation projects that demonstrate practical Linux administration and DevOps scripting skills — from beginner backup automation to advanced user provisioning.

Each script emphasizes real-world system management, logging, error handling, and automation best practices.

---

## Project 1 — Automated Backup & Restore Tool

**Level:** Beginner  
**Objective:** Automate directory backups and allow restoration of previous backups.

### Features
- Interactive menu-driven interface  
- Creates compressed backup archives with timestamps  
- Stores backups in chosen destination directory  
- Logs operations to `backup.log`  
- Lists available backups for restoration  
- Handles invalid paths and failures safely  

### Output Format
backup-YYYY-MM-DD_HHMMSS.tar.gz

### Concepts Demonstrated
- `read` for user input  
- `case` statements for menu selection  
- Functions for modular scripting  
- `tar -czf` and `tar -xzf` for compression  
- `date` command for timestamps  
- Output redirection `>>`  
- Exit status handling  

### Usage
```bash
chmod +x backup_tool.sh
./backup_tool.sh
```

### Project 1 Screenshot
#### 1. Backup Screen
<img width="880" height="684" alt="Screenshot 2026-02-27 at 17 45 30" src="https://github.com/user-attachments/assets/443f0674-5226-4029-a2b9-4cd5cb821e50" />

#### 2. Restore Screen
<img width="846" height="682" alt="Screenshot 2026-02-27 at 17 47 34" src="https://github.com/user-attachments/assets/d5ce8f1e-5210-4584-9836-d0e49261a575" />

#### 3. Exiting Screen
<img width="856" height="708" alt="Screenshot 2026-02-27 at 17 48 13" src="https://github.com/user-attachments/assets/01806803-f90d-42b2-b8de-9da72f65d593" />






## Project 2 — System Health Monitor & Report Generator

**Level:** Intermediate  
**Objective:** Generate a professional system health report with resource monitoring and alerts.

### Features
- Generates system health report file  
- Displays system identity and uptime  
- Reports CPU load, memory usage, and disk usage  
- Shows top 5 CPU-consuming processes  
- Detects high resource usage (>80%)  
- Logs warnings to `alerts.log`  

### Output File
health-report-YYYY-MM-DD.txt


### Concepts Demonstrated
- Command substitution `$(...)`  
- Pipes `|`  
- Text processing with `awk` and `cut`  
- Process monitoring with `ps`  
- Disk usage analysis with `df -h`  
- Memory monitoring with `free -h`  
- Conditional checks and functions  

### Usage
```bash
chmod +x system_health_monitor.sh
./system_health_monitor.sh
```
### Project 2 Screenshot

#### 1. System Health Monitor & chmod Screen
<img width="881" height="657" alt="Screenshot 2026-02-26 at 14 00 34" src="https://github.com/user-attachments/assets/53688684-46a5-4ed6-b275-7df8f0cd2384" />

#### 2. Report Screen 1
<img width="889" height="724" alt="Screenshot 2026-02-26 at 14 02 45" src="https://github.com/user-attachments/assets/d4d80f23-d5db-49e9-a964-5085008706c5" />

#### 3. Report Screen 2
<img width="890" height="678" alt="Screenshot 2026-02-26 at 14 03 31" src="https://github.com/user-attachments/assets/cff0116b-a57b-46c6-86b7-4ff684349c36" />




## Project 3 — User & Permission Provisioning Automation Tool

**Level:** Advanced  
**Objective:** Automate Linux user provisioning and permission management from a CSV file.

### Features
- Reads users from CSV file  
- Creates groups if they do not exist  
- Creates users with assigned shells  
- Adds users to specified groups  
- Creates project directories for each user  
- Sets ownership and permissions automatically  
- Generates provisioning summary  
- Supports simulation and rollback modes  
- Enforces root privilege execution  

### CSV Format
** username,group,shell **
1. Alade,developers,/bin/bash
2. Chika,designers,/bin/zsh


### Concepts Demonstrated
- CSV parsing with `while IFS=, read`  
- `useradd`, `groupadd`, `usermod`  
- Directory permission management  
- Argument parsing  
- `$EUID` validation for root access  
- Arrays for tracking created resources  
- DevOps-style rollback mechanism  

### Usage

**Normal execution**
```bash
sudo ./provision_users.sh users.csv
```

### Simulation mode
```bash
sudo ./provision_users.sh users.csv --dry-run
```

### Rollback mode
```bash
sudo ./provision_users.sh users.csv --rollback
```


## Skills Demonstrated Across Projects
- Linux system administration  
- Bash scripting and automation  
- File compression and restoration  
- System monitoring and reporting  
- User and permission management  
- Logging and error handling  
- DevOps automation practices  

---

## Recommended Environment
- Ubuntu / Debian Linux  
- Bash shell  
- Root privileges (for provisioning tool)  

---

## Learning Outcomes

After completing these projects, you should be able to:

- Automate system maintenance tasks  
- Monitor Linux system health programmatically  
- Manage users and permissions via scripts  
- Build production-style Bash automation tools  
- Apply DevOps thinking to Linux administration  

---

## Author

Humphrey Ikhalea  
DevOps/Software Engineer  
Lagos, Nigeria
