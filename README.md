# APPLICATION_DEPLOYMENT-

A production-grade, containerized Next.js application deployed on AWS using Infrastructure as Code with comprehensive monitoring, security, and cost optimization strategies.

---

## 📋 Table of Contents

- [Deployment Architecture](#deployment-architecture)
- [AWS Services](#aws-services)
- [Cost Optimization](#cost-optimization)
- [Security Measures](#security-measures)
- [Scaling Strategy](#scaling-strategy)
- [Monitoring & Maintenance](#monitoring--maintenance)
- [Quick Start](#quick-start)

---

## 🏗️ Deployment Architecture

### Deployment Type

This is a **fully managed, containerized AWS ECS Fargate deployment** with the following characteristics:

- **Containerization**: Next.js application packaged in Docker containers
- **Orchestration**: AWS ECS (Elastic Container Service) using Fargate launch type
- **Compute Model**: Serverless - No need to manage EC2 instances
- **Distribution**: CloudFront CDN for global content delivery
- **Load Balancing**: Application Load Balancer (ALB) for traffic distribution
- **Database**: DynamoDB for NoSQL data persistence
- **Infrastructure**: Infrastructure as Code using Terraform

### Architecture Diagram

```
Internet
    ↓
CloudFront (CDN)
    ↓
Application Load Balancer (ALB)
    ↓
ECS Fargate Tasks (Auto-scaled)
    ↓
DynamoDB (Serverless Database)
```

---

## 🎯 Design Decisions

- **Serverless compute with ECS Fargate**: avoids EC2 management and aligns with pay-per-use costs for container workloads.
- **CloudFront in front of ALB**: improves global performance, enables HTTPS enforcement, and reduces origin load.
- **Application Load Balancer**: supports dynamic routing and health checks for container tasks.
- **DynamoDB On-Demand**: chosen for automatic scaling, low operational overhead, and unpredictable traffic patterns.
- **Private ECS tasks**: isolates the application from direct internet access while allowing inbound traffic only through the ALB.
- **Terraform modularization**: separates networking, security, compute, monitoring, and database resources for reuse and maintainability.
- **CloudWatch monitoring and alarms**: built in to detect CPU/memory issues, support scaling, and enable fast incident response.
- **Least-privilege IAM roles**: task execution and app roles are scoped to only required AWS resources.

## ⚙️ Assumptions

- An AWS account with permissions to manage ECS, ECR, CloudFront, ALB, DynamoDB, IAM, CloudWatch, SNS, and networking resources is available.
- Terraform state is managed externally or via a supported backend such as S3 with locking.
- The repository is deployed into distinct `dev` and `prod` environments, with environment-specific variables configured under `terraform/environments/`.
- Container images will be built and pushed to ECR before ECS deployment.
- TLS certificates and DNS configuration for CloudFront are provisioned or managed outside this repository if required.
- The application is designed to run on port 3000 inside the container and expose traffic through the ALB.

## 🚧 Limitations & Improvements

### Current limitations
- No built-in multi-region or disaster recovery deployment strategy.
- No automated blue/green or canary deployment process is included.

- No explicit WAF or advanced edge security policy is configured for CloudFront.


### Suggested improvements
- Add a CI/CD pipeline for fully automated build, test, and deploy flows.
- Implement blue/green or canary deployments for safer releases.
- Add AWS WAF rules and bot mitigation at the CloudFront layer.
- Add a secure secrets management integration with AWS Secrets Manager or Parameter Store.
- Enable multi-region deployment or backup recovery options for improved resilience.
- Add more detailed cost reporting and usage dashboards.
- Extend the architecture documentation with a dependency diagram for internal services and data flows.

---

## 🔧 AWS Services

### Core Services

| Service | Purpose | Configuration |
|---------|---------|---|
| **ECS Fargate** | Container orchestration & compute | Serverless, pay-per-use |
| **ECR** | Docker image registry | Stores Next.js app container images |
| **Application Load Balancer (ALB)** | Traffic distribution | Routes requests across ECS tasks |
| **CloudFront** | Content delivery network | Caches content, reduces latency globally |
| **DynamoDB** | NoSQL database | Pay-per-request billing mode |
| **VPC** | Network isolation | Multi-AZ deployment across public/private subnets |
| **Security Groups** | Network firewall | Restrict traffic to authorized sources |
| **IAM** | Access control | Task execution and application roles |
| **CloudWatch** | Monitoring & logging | Logs, metrics, alarms, and dashboards |
| **SNS** | Alert notifications | Email notifications for alarms |

### Component Modules

```
terraform/modules/
├── alb/                    # Load balancer configuration
├── cloudfront/             # CDN distribution
├── dynamodb/               # Database setup
├── ecr/                    # Container registry
├── ecs/                    # Container orchestration
├── ecs_autoscaling/        # Auto-scaling policies
├── iam/                    # Identity & permissions
├── monitoring/             # CloudWatch logging & alarms
├── networking/             # VPC, subnets, NAT gateways
└── security_groups/        # Network ACLs & rules
```

---

## 💰 Cost Optimization

### 1. **Fargate Spot Instances**
- Uses AWS Fargate for compute without managing EC2 instances
- Can leverage Fargate Spot for 70% cost savings on suitable workloads
- Pay only for resources consumed (CPU, memory, storage)

### 2. **DynamoDB On-Demand Pricing**
- **Billing Mode**: `PAY_PER_REQUEST`
- No provisioned capacity - scales automatically with demand
- Ideal for unpredictable workloads
- No over-provisioning of unused resources

### 3. **CloudFront Caching**
- Reduces load on origin ALB
- Decreases data transfer costs
- Serves static content from edge locations worldwide
- Cache policies configured for optimal hit rates

### 4. **Networking Optimization**
- NAT Gateway sharing across availability zones
- VPC endpoints for AWS services (reduces internet gateway costs)
- Private subnets for ECS tasks (avoids unnecessary public IP allocation)

### 5. **Auto-Scaling Down**
- Scales down unused capacity during low traffic periods
- Minimum capacity set to 1 task, maximum configurable
- Step scaling with cooldown periods prevents thrashing

### 6. **CloudWatch Logs Retention**
- Configurable log retention (default: 30 days)
- Prevents unlimited log storage costs
- Automated cleanup of old logs

### 7. **Multi-AZ Efficiency**
- Distributes load across 2 availability zones
- High availability without redundant over-provisioning
- NAT gateways shared to minimize costs

---

## 🔒 Security Measures

### 1. **Network Segmentation**
- **Public Subnets**: ALB for internet-facing traffic
- **Private Subnets**: ECS tasks isolated from internet
- **NAT Gateway**: Controlled outbound internet access for private resources
- Multi-AZ deployment for high availability

### 2. **Security Groups (Firewall Rules)**

#### ALB Security Group
- Allows **HTTP (80)** from anywhere `0.0.0.0/0`
- Allows **HTTPS (443)** from anywhere `0.0.0.0/0`
- Enforces inbound rules on ingress

#### ECS Security Group
- Allows traffic **only from ALB** on port 3000
- Denies direct internet access to container tasks
- Restricts to source security group (not CIDR blocks)

### 3. **Identity & Access Management (IAM)**
- **Task Execution Role**: Permissions to pull images from ECR, write logs to CloudWatch
- **Task Role**: Application-specific permissions to access DynamoDB, other AWS services
- Least privilege principle - minimal required permissions per role

### 4. **Data Protection**
- **DynamoDB Point-in-Time Recovery (PITR)**: Enabled
  - Protects against accidental deletions
  - Automatic backups for 35 days
- Encryption at rest for all data

### 5. **Container Security**
- Docker images stored in private ECR registry
- Health checks prevent unhealthy containers from receiving traffic
- Container images built with security best practices

### 6. **HTTPS/TLS**
- CloudFront enforces HTTPS redirect
- Viewer protocol policy: `redirect-to-https`
- TLS 1.2+ for all connections

### 7. **Secrets Management**
- Environment variables configured via ECS task definition
- AWS Secrets Manager integration available
- No hardcoded credentials in images

---

## 📈 Scaling Strategy

### Auto-Scaling Configuration

#### Scalable Targets
- **Service**: ECS service tasks
- **Metric**: CPU Utilization
- **Minimum Capacity**: 1 task
- **Maximum Capacity**: Configurable (default: 3-5 tasks)

#### Scale-Out Policy (Increase Capacity)
- **Trigger**: CPU utilization > 70% (configurable)
- **Action**: Add 1 task
- **Cooldown**: 60 seconds
- **Evaluation**: Average across 2 periods of 60 seconds each

#### Scale-In Policy (Decrease Capacity)
- **Trigger**: CPU utilization < 30% (configurable)
- **Action**: Remove 1 task
- **Cooldown**: 120 seconds (prevents thrashing)
- **Evaluation**: Average across 2 periods of 60 seconds each

### Health Checks
- **ECS Health Check**: Every 30 seconds with 5-second timeout
- **Endpoint**: `/api/health` on port 3000
- **Behavior**: 3 consecutive failures mark task as unhealthy
- **Start Period**: 15 seconds (grace period for container startup)

### Benefits
- ✅ Handles traffic spikes automatically
- ✅ Reduces costs during low-traffic periods
- ✅ Maintains consistent application performance
- ✅ Multi-AZ distribution for fault tolerance

---

## 📊 Monitoring & Maintenance

### CloudWatch Monitoring

#### Log Aggregation
- **Log Group**: `/ecs/{environment}-app`
- **Logs Driver**: CloudWatch (awslogs)
- **Stream Prefix**: `app`
- **Retention**: Configurable (e.g., 30 days)
- **Real-time Analysis**: Query logs for debugging and insights

#### Metrics Tracked
- **ECS Metrics**:
  - CPU Utilization (%)
  - Memory Utilization (%)
  - Task Count
  - Service Deployment Status
  
- **ALB Metrics**:
  - Target Response Time
  - HTTP 4xx/5xx Error Counts
  - Active Connection Count
  - Request Count

#### Container Insights
- Enabled on ECS cluster for enhanced monitoring
- Provides:
  - Container-level performance data
  - Task-level resource utilization
  - Service health status
  - Automated dashboards

### Alarms & Notifications

#### CloudWatch Alarms
1. **CPU High Alert**
   - Threshold: 70% CPU utilization
   - Evaluation: 2 periods of 60 seconds
   - Action: Triggers scale-out policy + email notification

2. **CPU Low Alert**
   - Threshold: 30% CPU utilization
   - Evaluation: 2 periods of 60 seconds
   - Action: Triggers scale-in policy

3. **Memory High Alert**
   - Threshold: 80% memory utilization
   - Evaluation: 2 periods of 60 seconds
   - Action: Email notification + manual investigation

#### SNS Notifications
- **SNS Topic**: `{environment}-alarms`
- **Subscription**: Email endpoint
- **Alerts**: All high-severity alarms sent via email
- **Frequency**: Prevents alarm fatigue with appropriate cooldowns

### Maintenance Tasks

#### Daily Maintenance
```bash
# Monitor CloudWatch dashboard
# Review logs for errors
# Check auto-scaling activity
```

#### Weekly Maintenance
```bash
# Review CPU/Memory utilization trends
# Verify backup/recovery status
# Check DynamoDB consumption patterns
# Review security group rules
```

#### Monthly Maintenance
```bash
# Audit IAM permissions
# Review CloudFront cache hit ratios
# Analyze cost allocation tags
# Update Terraform variables if needed
# Run disaster recovery drills
```

### Accessing Monitoring Data

#### Via AWS Console
1. CloudWatch → Logs → Filter by log group `/ecs/{environment}-app`
2. CloudWatch → Metrics → Select ECS namespace
3. CloudWatch → Alarms → View alarm status

#### Via Terraform Outputs
```bash
# Get key endpoints and resources
terraform output -json
```

#### Via CLI
```bash
# View logs
aws logs tail /ecs/dev-app --follow

# Get metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/ECS \
  --metric-name CPUUtilization \
  --dimensions Name=ClusterName,Value=dev-cluster
```

---

## 🚀 Quick Start

### Prerequisites
- AWS Account with appropriate permissions
- Terraform 1.7.0+
- Docker installed
- AWS CLI configured

### Deployment Steps

#### 1. Configure Environment Variables
```bash
cd terraform/environments/dev
# Edit terraform.tfvars with your settings
```

#### 2. Build & Push Docker Image
```bash
cd app
docker build -t app:latest .
aws ecr get-login-password | docker login --username AWS --password-stdin <ECR_URI>
docker tag app:latest <ECR_URI>/app:latest
docker push <ECR_URI>/app:latest
```

#### 3. Deploy Infrastructure
```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

#### 4. Access Application
```bash
# Get CloudFront domain from outputs
terraform output cloudfront_domain_name
```

### Environment Variables
- `AWS_REGION`: AWS region (default: us-east-1)
- `ENVIRONMENT`: dev or prod
- `TF_WORKING_DIR`: terraform/environments/{env}

---

## 📝 CI/CD Pipeline

### GitHub Actions Workflow (`.github/workflows/deploy.yml`)
- Triggers on push to `main` branch
- Runs Terraform validation and apply
- Builds and pushes Docker image to ECR
- Deploys updated image to ECS
- Supports both dev and prod environments

---

## 🔐 Production Best Practices

1. **Enable VPC Endpoints** for AWS services (reduces costs, improves security)
2. **Use AWS Secrets Manager** for sensitive credentials
3. **Enable S3 bucket versioning** for Terraform state
4. **Enable MFA Delete** on state bucket
5. **Configure CloudTrail** for API audit logs
6. **Set up Budget Alerts** for cost control
7. **Regular backups** - DynamoDB PITR enabled
8. **Disaster recovery plan** - Test restore procedures monthly

---

## 📞 Support & Troubleshooting

### Common Issues

**ECS Task failing to start**
- Check CloudWatch logs: `/ecs/{environment}-app`
- Verify IAM task role permissions
- Check security group rules

**High CPU/Memory alerts**
- Review application logs for errors
- Check auto-scaling metrics
- Consider increasing task CPU/memory allocation

**CloudFront caching issues**
- Clear CloudFront cache from console
- Verify cache behavior policies
- Check origin response headers

---

## 📄 License

This project is part of an internal deployment pipeline.

---

**Last Updated**: May 2026  
**Infrastructure as Code**: Terraform v1.7.0  
**Application Runtime**: Next.js 14 + Node.js