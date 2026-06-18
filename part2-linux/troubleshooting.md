# Part 2: Linux System Administration

## A. Scenario

A web server (10.0.1.50) is unresponsive and SSH connection is timing out.

## 1. Network Connectivity Check

From jump host:

```bash
ping 10.0.1.50
```

Check route:

```bash
traceroute 10.0.1.50
```

Check SSH port:

```bash
nc -zv 10.0.1.50 22
```

If connectivity fails, check:
- Security groups
- Network ACL
- Route tables
- Instance status checks

---

## 2. SSH Service Check

Login through SSM/console and verify:

```bash
sudo systemctl status sshd
```

Check listening port:

```bash
sudo ss -tulpn | grep :22
```

Restart:

```bash
sudo systemctl restart sshd
```

---

## 3. If SSH is running but connection fails, I will check the following

Check firewall:

```bash
sudo iptables -L -n
```

Check SSH config:

```bash
sudo sshd -t
```

Review:

```bash
sudo cat /etc/ssh/sshd_config
```

Check fail2ban:

```bash
sudo fail2ban-client status sshd
```

---

## 4. Compute Metrices Check

CPU:

```bash
top
```

Memory:

```bash
free -h
```

Disk:

```bash
df -h
```

Inodes:

```bash
df -i
```

---

## 5. Log Checks

System logs:

```bash
sudo journalctl -xe
```

SSH logs:

Ubuntu:

```bash
sudo tail -100 /var/log/auth.log
```

RHEL:

```bash
sudo tail -100 /var/log/secure
```

Kernel:

```bash
dmesg -T | tail
```

---

# B. Docker Container Task

Dockerfile requirements:
- Python 3.11
- Multi-stage build
- Non-root user
- Health check
- Secure startup

Note: Seperate Dockerfile is inside the folder.
