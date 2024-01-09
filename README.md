# ETCD Backup and Restore Scripts

## Overview
This repository contains scripts for backing up and restoring the ETCD database in Kubernetes environments. These scripts facilitate the creation of timestamped backup files, handle their compression, and manage the retention of these backups by deleting older files.

## Features
- Automated backup of ETCD database.
- Backup file compression.
- Backup retention management.
- Ansible playbook for easy deployment and execution.
- Restoration script for ETCD data.

## Prerequisites
- Root access to a Kubernetes environment with ETCD (Masters).
- Required tools: etcdctl, gzip, crontab, and standard Linux utilities (date, find, etc.).
- Ansible for running playbooks.

## Installation
1. Clone the repository:
```
   git clone https://github.com/mk3-v8/etcd-backup-script.git
   cd etcd-backup-script
```
## Usage
### Backup
Deploy and run the backup script using Ansible:
```
ansible-playbook backup-playbook.yml
```
### Restore
List backups and prompt for the backup file to restore:
```
ansible-playbook restore-playbook.yml
```

### Environment Variables (optional)
- RETENTION_DAYS: Number of days to retain the backup files.
- BACKUP_DIR: Directory where backup files are stored.

## Customization
You can modify the CRON_SCHEDULE variable within the script to set a custom schedule for the cron job.

## Contribution
Contributions to this script are welcome. Please fork the repository and submit a pull request with your changes.

## License

MIT License

Copyright (c) 2024 Mohammed Aladwani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


## Contact
#### Email: mkmladwani@hotmail.com
---

*Note: This script is provided as-is with no guarantees. Please ensure you test it in your environment before using it in production.*
