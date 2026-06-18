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
 │ Mumbai Region       │             │ Mumbai Region       │
 └─────────┬───────────┘             └─────────┬───────────┘
           │                                   │
           └──────────────┬────────────────────┘
                          │
                Private Route 53 Resolver
                          │
         ┌────────────────┴─────────────────┐
         │                                  │
         ▼                                  ▼
   Application VPC                  Future VPCs
   (Private Subnets)                (Expansion)
