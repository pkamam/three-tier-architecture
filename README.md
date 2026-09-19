# three-tier-architecture
Create 3 tier architecture for my learning

Reference: https://medium.com/@aaloktrivedi/building-a-3-tier-web-application-architecture-with-aws-eb5981613e30

This base network consists of:

A VPC.
Two (2) public subnets spread across two availability zones (Web Tier).
Two (2) private subnets spread across two availability zones (Application Tier).
Two (2) private subnets spread across two availability zones (Database Tier).
One (1) public route table that connects the public subnets to an internet gateway.
One (1) private route table that will connect the Application Tier private subnets and a NAT gateway.

Tier 1: Web tier (Frontend)
The Web Tier, also known as the ‘Presentation’ tier, is the environment where our application will be delivered for users to interact with. For Brainiac, this is where we will launch our web servers that will host the frontend of our application.

What we’ll build:

A web server launch template to define what kind of EC2 instances will be provisioned for the application.
An Auto Scaling Group (ASG) that will dynamically provision EC2 instances.
An Application Load Balancer (ALB) to help route incoming traffic to the proper targets.

Front end
What we’ll build:

A web server launch template to define what kind of EC2 instances will be provisioned for the application.
An Auto Scaling Group (ASG) that will dynamically provision EC2 instances.
An Application Load Balancer (ALB) to help route incoming traffic to the proper targets.


                         Internet
                            │
                            │
                            ▼
             ┌──────────────────────────┐
             │ three-tier-webServer-alb   │
             │     Internet-facing      │
             │          HTTP :80        │
             └────────────┬─────────────┘
                          │
                          ▼
                    Target Group
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
       Public Subnet 1         Public Subnet 2
       us-east-1a              us-east-1b
              │                       │
              ▼                       ▼
         EC2 t2.micro            EC2 t2.micro
              │                       │
              └───────────┬───────────┘
                          │
                          ▼
                         ASG
                    min = 2
                 desired = 2
                    max = 5
                          │
                          ▼
                 CPU target = 50%
