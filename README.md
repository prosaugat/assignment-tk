# TechKraft - Senior DevOps/Infrastructure Engineer Take-Home Assignment

## Contact Info

**Name:** Saugat Nepal
**Email:** [prosaugat.np@gmail.com](mailto:prosaugat.np@gmail.com)
**Phone:** +977 9849785100 / +977 9851458100
**LinkedIn:** https://linkedin.com/in/prosaugat
**GitHub:** https://github.com/prosaugat
**Blog/Portfolio:** https://www.saugatnepal.com.np/

---

# Assignment Overview

This repository contains my solutions for the TechKraft Senior DevOps/Infrastructure Engineer Take-Home Assignment. The solutions focus on infrastructure design, security, automation, cloud architecture, Linux administration, scripting, CI/CD best practices, and Kubernetes deployment patterns.

---

# Repository Structure

```text
/
├── README.md
├── part1-terraform/
│   └── analysis.md
├── part2-linux/
│   ├── troubleshooting.md
│   └── Dockerfile
├── part3-python/
│   ├── ec2_monitor.py
│   └── config.json
├── part4-bash/
│   └── analyze_nginx_logs.sh
├── part5-network/
│   └── architecture.md
├── part6-cicd/
│   └── improvements.md
└── k8s/
    └── deployment.yaml
```

---

# Part 1 – Infrastructure Analysis

### Objective

Review and analyze Terraform code containing security and architectural issues.

### Solution Summary

* Identified security vulnerabilities including exposed SSH access, hardcoded database credentials, disabled backups, disabled deletion protection, and unrestricted outbound traffic.
* Identified architectural weaknesses such as lack of private subnets, missing NAT gateways, absence of high availability design, lack of load balancing, and missing monitoring.
* Proposed a production-ready architecture utilizing:

  * Multi-AZ deployment
  * Public and private subnet separation
  * Application Load Balancer
  * Route 53
  * Auto Scaling Groups
  * RDS Multi-AZ
  * Infrastructure as Code best practices

---

# Part 2 – Linux System Administration

### Objective

Troubleshoot an unresponsive Linux server and create a production-ready Docker image.

### Solution Summary

* Documented a structured troubleshooting process:

  * Network connectivity validation
  * SSH diagnostics
  * System resource analysis
  * Log inspection
* Created a multi-stage Dockerfile for a Flask application:

  * Python 3.11
  * Non-root user
  * Health check support
  * Minimal production image
  * Secure startup configuration

---

# Part 3 – Python Scripting

### Objective

Develop an AWS EC2 monitoring utility.

### Solution Summary

* Utilized boto3 to query EC2 instances and CloudWatch metrics.
* Generated JSON reports containing:

  * Instance details
  * Average CPU utilization
  * Minimum CPU utilization
  * Maximum CPU utilization
* Implemented:

  * Logging
  * Error handling
  * Type hints
  * CLI argument parsing using argparse
* Added threshold-based alert flagging.

---

# Part 4 – Bash Scripting

### Objective

Analyze Nginx access logs using standard Linux tools.

### Solution Summary

Created a Bash script that:

* Parses Nginx access logs
* Identifies top 10 source IP addresses
* Calculates 4xx and 5xx error percentages
* Identifies top 10 endpoints
* Handles malformed log entries gracefully
* Generates a formatted report

Tools used:

* awk
* sed
* sort
* uniq
* wc

---

# Part 5 – Network Architecture Design

### Objective

Design a highly available DNS architecture.

### Solution Summary

Designed a redundant DNS solution using:

* AWS Route 53
* Route 53 Health Checks
* Primary and Secondary Unbound DNS servers
* Multi-AZ deployment
* CloudWatch monitoring

Key benefits:

* Eliminates DNS Single Point of Failure
* Automated failover
* Reduced latency for Nepal-based users
* Cost-effective implementation
* Improved operational resilience

---

# Part 6 – CI/CD Pipeline Review

### Objective

Review and improve the existing GitHub Actions pipeline.

### Solution Summary

Identified several shortcomings:

* No security scanning
* No approval workflow
* No rollback mechanism
* No environment separation
* No artifact management

Recommended improvements:

* SAST and dependency scanning
* Multi-environment deployments
* Manual approval gates
* Blue/Green deployment strategy
* Automated rollback procedures
* Enhanced observability

---

# Bonus – Kubernetes Deployment

### Objective

Deploy the Flask application using Kubernetes.

### Solution Summary

Implemented:

* ConfigMap
* Deployment
* Service
* Horizontal Pod Autoscaler (HPA)

Features:

* Minimum 2 replicas
* CPU and memory resource limits
* Readiness probes
* Liveness probes
* Environment variables from ConfigMap
* Autoscaling based on CPU utilization

---

# Assumptions

The following assumptions were made while completing the assignment:

1. AWS is the primary cloud provider.
2. Production workloads require high availability and Multi-AZ design.
3. Security best practices are prioritized over minimum implementation requirements.
4. Monitoring and observability are considered mandatory for production environments.
5. Kubernetes cluster and Metrics Server are already available for HPA functionality.
6. DNS workloads are moderate and can be handled by Route 53 with lightweight resolver instances.
7. CI/CD deployments target cloud-hosted workloads.

---

# Time Spent

| Section                     | Time Spent |
| --------------------------- | ---------- |
| Part 1 - Terraform Analysis | 20 Minutes |
| Part 2 - Linux & Docker     | 25 Minutes |
| Part 3 - Python Scripting   | 35 Minutes |
| Part 4 - Bash Scripting     | 25 Minutes |
| Part 5 - Network Design     | 20 Minutes |
| Part 6 - CI/CD Review       | 15 Minutes |
| Kubernetes Bonus            | 15 Minutes |
| Documentation & Review      | 10 Minutes |

**Total Time:** Approximately 2.75 Hours

---

# Tools & Versions Used

### Cloud & Infrastructure

* AWS
* Route 53
* EC2
* CloudWatch
* Terraform v1.6+

### Operating Systems

* Ubuntu 22.04 LTS

### Programming & Scripting

* Python 3.11
* Bash 5.x

### Web Server

* Nginx

### Containerization

* Docker 24+

### Kubernetes

* Kubernetes v1.28+
* Horizontal Pod Autoscaler

### CI/CD

* GitHub Actions

### Version Control

* Git 2.x
* GitHub

---

# Final Notes

This assignment was approached with a production-first mindset, emphasizing security, reliability, scalability, maintainability, and operational excellence. Where appropriate, recommendations exceeded the minimum requirements to demonstrate real-world infrastructure engineering practices and leadership-level decision making.

Thank you for reviewing my submission.
