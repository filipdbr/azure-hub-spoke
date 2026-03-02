# azure-az104-sandbox
A ready-to-deploy lab environment designed to help you ace the AZ-104 certification exam.

## Why this project?
I built this infrastructure while preparing for **AZ-104** and learning **Terraform**, mainly to have a place to practice. Now I’m sharing it with the community.

This environment is a sandbox to run exercises, test configurations, and get comfortable with Azure administration in a hands-on way.

The goal is to practice various scenarius, which is helpfull during AZ-104 exam and in real life while working with Azure.

## Conceputal Diagram

![Conceptual diagram](docs/architecture_concept.png "Conceptual diagram")

## Key Features

This lab isn't just a simple VM deployment. It includes several real-world Azure configurations:
* **True Hub & Spoke**: Two peered VNets with isolated roles.
* **Hybrid Load Balancing**: A public **Application Gateway** for the Web layer and a private **Internal Load Balancer** for the App layer.
* **Traffic Control (UDR)**: Custom routing that forces all internet-bound traffic through the **Azure Firewall** for inspection.
* **Zero Public IPs on VMs**: All virtual machines are kept in private subnets. Access is managed strictly via **Azure Bastion**.
* **High Availability**: Resources are spread across multiple **Availability Zones** in the Poland Central region.
* **Modular Code**: Infrastructure is broken down into reusable modules, making it easy to scale or modify.

## Network Traffic Flow

This environment is built on a Hub & Spoke architecture, with traffic routing managed through the following paths:

### 1. Inbound Traffic (External)
The end user requests enter the system through the **Application Gateway's** Public IP. As a Layer 7 load balancer, it evaluates the traffic and routes it to the **Web Tier** (Virtual Machine Scale Set) located in the `snet-prod-pl-appgw` subnet.

### 2. Internal Communication
Communication between the Web and Application tiers is handled by an **Internal Load Balancer (ILB)**. This ensures that requests are distributed efficiently across **App VMs** and provides redundancy across different Availability Zones.

### 3. Outbound Traffic and Management (Internal)
* **Centralized Inspection**: All outbound traffic from the Spoke network is redirected to the **Azure Firewall** in the Hub via **User-Defined Routes (UDR)**. This allows for centralized monitoring and traffic filtering.
* **Administrative Access**: Virtual Machines do not have public IP addresses. Secure management is performed through **Azure Bastion**, which provides an SSH tunnel without exposing the servers to the internet.
* **Connectivity**: The Hub and Spoke VNets communicate via **VNet Peering**, which allows resources to talk to each other across different networks.

## Tech Stack
* **Cloud:** Microsoft Azure
* **IaC:** Terraform
* **CLI:** Azure CLI & GitHub CLI

## Important: Beware of Your Budget!

Please be aware that hosting this infrasture in Azure is not free. This project uses some "Enterprise-grade" resources to give you a real-world experience, and Microsoft charges for them by the hour.

### The Most Expensive Resources
* **Azure Firewall**: This is the most expensive part of the lab (roughly $0.90/hr).
* **Application Gateway & Bastion**: These are mid-range costs (about $0.20 - $0.25/hr). They are essential for the architecture, but they add up over time.
* **Virtual Machines**: These are relatively cheap (~$0.05/hr), but remember they still charge you as long as they exist.

### Tips:
1. **The "Golden Rule"**: Always run `terraform destroy` the moment you finish your practice session. Don't leave it for "tomorrow."
2. **Check your Portal**: After destroying, double-check the Azure Portal to make sure the Resource Group is actually empty.
3. **Use Free Credits**: If you are a student or on a trial, keep a close eye on your remaining balance in the Azure Cost Management dashboard.

## Prerequisites

### 1. Azure Account
You’ll need an active Azure subscription to follow along. 
* **If you're a student:** Use the [Azure for Students](https://azure.microsoft.com/free/students/) offer. You get $100 in credits and some free services without even needing a credit card.
* **Otherwise:** Grab a [Free Trial account](https://azure.microsoft.com/free/) with $200 credit.

### 2. Terraform
You’ll also need the Terraform CLI to deploy the infrastructure. You can find the official, step-by-step installation guide for your OS here:

**Installation Guide:** [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Once installed, verify it by running:
`terraform -version` in CLI.

## Project Infrastructure

### Project Strategy
As I am based in Poland, the primary application infrastructure is hosted in the **Poland Central** region to ensure low latency and data residency compliance. The environment is designed using a modular approach, allowing for high availability through Availability Zones and secure connectivity.

You can easily change the deployment region in [variables](variables.tf) by changing location default value.

## Repository Structure

The project is organized to separate concerns (Networking, Compute, Security), making the code easier to read and maintain:

### Root Configuration
* **`network.tf`**: Sets up the VNet architecture, subnets, and peering.
* **`security.tf`**: Manages the Azure Firewall, Bastion, and Network Security Groups (NSGs).
* **`compute.tf`**: Handles the Virtual Machine Scale Sets and standalone App VMs.
* **`loadbalancing.tf`**: Configures the Application Gateway and the Internal Load Balancer, including the backend associations.
* **`main.tf`**: Defines the Resource Group and links the core components together.
* **`variables.tf` & `terraform.tfvars`**: Where you customize the deployment (location, VM sizes, names).

### Reusable Modules (`/modules`)
* **`network/`**: Logic for dynamic VNet and subnet creation.
* **`compute/`**: Blueprints for Linux VMs and Scale Sets.
* **`load_balancing/`**: Separate modules for the App Gateway and Internal LB.

## How to Deploy
Follow these steps:

1. **Authenticate:** Log in to your Azure account via CLI.
   `az login`
2. **Initialize:** Download the required Terraform providers and initialize the working directory.
   `terraform init`
3. **Plan:** Preview the resources that will be created.
   `terraform plan`
4. **Apply:** Deploy the infrastructure to your Azure subscription (you will be prompted to type `yes`).
   `terraform apply`

**Note: Don't forget to run `terraform destroy` when you're done practicing to avoid unnecessary cloud charges!*

## How to verify the setup

Once Terraform finishes the deployment, you can run these simple tests to make sure everything is configured correctly:

### 1. Check the Web Entrance
Copy the **Public IP of the Application Gateway** (find it in the Azure Portal or via Terraform outputs) and paste it into your browser. You should see the default page of your Web VMs. This confirms the App Gateway and VMSS are talking to each other.

### 2. Test the "Bouncer" (Azure Firewall)
Log in to one of your VMs via **Azure Bastion**. Open the terminal and try to ping a public website or run `curl -I https://www.google.com`. 
* If it works: The traffic is successfully leaving the network.
* Advanced: Check the Firewall logs in the Portal to see your request being "allowed" and routed through the Hub.

### 3. Verify High Availability
In the Portal, manually stop one of your App VMs. Refresh the Application Gateway URL. The site should still be up because the **Internal Load Balancer** automatically shifted the traffic to the second, healthy VM.

### 4. Management Access
Try to connect to a VM using its private IP through the **Bastion** service. If you can get in without a Public IP assigned to the VM itself, your management plane is secure and working.

# Roadmap (Work in Progress)
This sandbox is continuously evolving. Here is the current implementation status:
* [x] Hub & Spoke VNet Architecture
* [x] VNet Peering with forwarded traffic enabled
* [x] Central Azure Firewall provisioning
* [x] User-Defined Routes (UDR) to force Spoke traffic through the Hub Firewall
* [x] Secure remote access via Azure Bastion
* [x] VMs
* [ ] DB config + deployment
* [ ] VPN
* [ ] private DNS for DB