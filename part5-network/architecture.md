# Part 5: Network Architecture Design

## Overview

The current architecture relies on a single Unbound DNS server running on one EC2 instance, creating a critical Single Point of Failure (SPOF). If the instance, AZ, or underlying host fails, all DNS resolution fails, impacting applications and services.

## Architecture Diagram

```text
                    ┌─────────────────────┐
                    │     Route 53        │
                    │  Public Hosted Zone │
                    └──────────┬──────────┘
                               │
                    Health Check Monitoring
                               │
             ┌─────────────────┴─────────────────┐
             │                                   │
             ▼                                   ▼
 ┌─────────────────────┐             ┌─────────────────────┐
 │ Primary DNS Server  │             │ Secondary DNS Server│
 │ Unbound EC2         │             │ Unbound EC2         │
 │ ap-south-1a         │             │ ap-south-1b         │
 └─────────┬───────────┘             └─────────┬───────────┘
           │                                   │
           └──────────────┬────────────────────┘
                          │
                Route 53 Resolver
                          │
         ┌────────────────┴─────────────────┐
         │                                  │
         ▼                                  ▼
   Application VPC                  Future VPCs
```

## Key Components

### Route 53 Public Hosted Zone
- Managed authoritative DNS service
- Global redundancy and Anycast routing
- Eliminates DNS SPOF

### Primary DNS Server like ns1
- EC2 t3.small running Unbound
- Located in ap-south-1a (Mumbai)

### Secondary DNS Server like ns2
- EC2 t3.small running Unbound
- Located in ap-south-1b (Mumbai)
- Automatic failover target

### Route 53 Health Checks
- TCP/UDP DNS monitoring
- 30-second interval
- 3 failure threshold

### Route 53 Resolver
- Internal VPC DNS resolution
- Hybrid cloud support
- Future on-prem integration

## Failover Logic

Normal Flow:
Route 53 → Primary DNS → Response

Failure Flow:
Health Check Failure → Route 53 Marks Unhealthy → Traffic Sent to Secondary DNS

Estimated Recovery Time: 60–90 seconds

## Latency Considerations for Nepal

Recommended AWS Region: Mumbai (ap-south-1)

Estimated Latency:
- Nepal → Mumbai: 35–60 ms or less
- Nepal → Singapore: 80–120 ms
- Nepal → Tokyo: 120–180 ms

## Security Considerations

- Restrict DNS access to required networks
- SSH only from Bastion Host
- AWS Shield Standard enabled
- CloudWatch monitoring and alerts

## Monitoring

Monitor:
- CPU Usage
- Memory Usage
- DNS Query Volume
- Health Check Status
- Network Throughput

Alerts:
- Email
- PagerDuty

## Monthly Cost Estimate

| Service | Monthly Cost |
|----------|-------------|
| Route 53 Hosted Zone | $0.50 |
| Health Checks | $1.00 |
| DNS Queries | $0.40 |
| Primary EC2 | $15 |
| Secondary EC2 | $15 |
| Monitoring | $3 |
| Data Transfer | $2 |

Total: Approximately $35–40/month

## Implementation Timeline

| Phase | Duration |
|---------|---------|
| Route 53 Setup | 1 Day |
| Secondary DNS Deployment | 1 Day |
| Health Checks | 0.5 Day |
| Monitoring | 0.5 Day |
| Testing | 1 Day |

Total: 3–4 Working Days

## Recommendation from my end

Use Amazon Route 53 as the authoritative DNS service and Route 53 Resolver for internal DNS. This removes server management overhead, eliminates DNS SPOFs, provides automatic redundancy, and aligns with cloud-native best practices.
