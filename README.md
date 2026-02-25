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
