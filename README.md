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
