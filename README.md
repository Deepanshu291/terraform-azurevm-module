# Azure VM Terraform Module

This Terraform module provisions an Azure Linux Virtual Machine with Code Server setup, including all necessary networking components for development purposes.

## 🏗️ Architecture

This module creates the following Azure resources:

- **Resource Group** - Container for all resources
- **Virtual Network** - Network infrastructure
- **Subnet** - Network segment for VM
- **Public IP** - Static IP with DNS label
- **Network Interface** - VM network connection
- **Network Security Group** - Firewall rules
- **Linux Virtual Machine** - Ubuntu VM with Code Server

## 📋 Prerequisites

Before using this module, ensure you have:

1. **Azure CLI** installed and configured
   ```bash
   # Install Azure CLI (Ubuntu/Debian)
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   
   # Login to Azure
   az login
   ```

2. **Terraform** installed (version >= 1.0)
   ```bash
   # Install Terraform
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   terraform --version
   ```

3. **Azure Subscription** with appropriate permissions
4. **Custom Azure Image** (Code Server image) in your Azure Compute Gallery

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/Deepanshu291/terraform-codeserver.git
cd terraform-codeserver/azureVM-tf
```

### 2. Configure Variables
Create or modify `terraform.tfvars` file:

```hcl
# Required Variables
subscription_id = "your-azure-subscription-id"
location = "Central India"
rg_name = "RG_codeserver"

# Optional Variables (defaults provided)
source_image_name = "codexdev"
# source_image_url will use the default path structure
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
```bash
terraform plan
```

### 5. Deploy the Infrastructure
```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

## 📁 Project Structure

```
azureVM-tf/
├── main.tf              # Main Terraform configuration
├── var.tf               # Variable definitions
├── terraform.tfvars     # Variable values (customize this)
├── terraform.tfstate    # Terraform state file (auto-generated)
└── README.md            # This file
```

## ⚙️ Configuration Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `subscription_id` | Azure subscription ID | string | `""` | Yes |
| `location` | Azure region for resources | string | - | Yes |
| `rg_name` | Resource group name | string | `"RG_codeserver"` | No |
| `source_image_name` | Custom VM image name | string | `"codexdev"` | No |
| `source_image_url` | Full path to custom image | string | Auto-generated | No |

## 🌐 Network Configuration

The module configures the following network settings:

- **Virtual Network**: `10.0.0.0/16`
- **Subnet**: `10.0.1.0/24`
- **Security Rules**:
  - SSH (port 22)
  - HTTP (port 80)
  - HTTPS (port 443)
  - Code Server (port 8080)

## 🖥️ VM Specifications

- **Size**: Standard_D2as_v5 (2 vCPUs, 8GB RAM)
- **OS**: Linux (Custom Code Server image)
- **Storage**: Standard LRS
- **Zone**: Zone 2
- **Authentication**: Password-based
  - Username: `deepanshu`
  - Password: `deepanshu@123` ⚠️ *Change this in production!*

## 📤 Outputs

After successful deployment, you'll get:

- **Public IP Address**: External IP of the VM
- **DNS Name**: Fully qualified domain name

```bash
# View outputs
terraform output
```

## 🔧 Demo Commands

### Basic Operations
```bash
# Initialize the project
terraform init

# Validate configuration
terraform validate

# Format Terraform files
terraform fmt

# Plan changes
terraform plan -var-file="terraform.tfvars"

# Apply changes
terraform apply -var-file="terraform.tfvars"

# Show current state
terraform show

# List all resources
terraform state list

# Get specific output
terraform output public_ip
terraform output dns_name

# Destroy infrastructure
terraform destroy
```

### Advanced Operations
```bash
# Plan with specific target
terraform plan -target=azurerm_virtual_machine.vm

# Apply with auto-approve
terraform apply -auto-approve

# Import existing resource
terraform import azurerm_resource_group.rg /subscriptions/{subscription-id}/resourceGroups/{rg-name}

# Refresh state
terraform refresh

# Show planned changes in JSON
terraform show -json terraform.tfplan
```

## 🔍 Troubleshooting

### Common Issues

1. **Authentication Error**
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

2. **Image Not Found**
   - Verify the `source_image_url` path
   - Ensure the custom image exists in your Azure Compute Gallery

3. **Permission Denied**
   - Check Azure RBAC permissions
   - Ensure you have Contributor role on the subscription

4. **Resource Already Exists**
   ```bash
   terraform import azurerm_resource_group.rg /subscriptions/{id}/resourceGroups/{name}
   ```

### Useful Commands for Debugging
```bash
# Enable detailed logging
export TF_LOG=DEBUG
terraform apply

# Check Azure resources
az group list
az vm list --output table

# Test VM connectivity
ssh deepanshu@<public-ip>
# Or using DNS name
ssh deepanshu@<dns-name>
```

## 🔒 Security Considerations

⚠️ **Important Security Notes:**

1. **Change Default Password**: The default password is hardcoded for demo purposes
2. **Use SSH Keys**: Consider using SSH key authentication instead of passwords
3. **Network Security**: Restrict source IP ranges in security group rules
4. **Secret Management**: Use Azure Key Vault for sensitive data

### Recommended Security Improvements
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key

# Use the public key in your Terraform configuration
```

## 🧹 Cleanup

To destroy all created resources:

```bash
terraform destroy
```

**Warning**: This will permanently delete all resources created by this module.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
- Create an issue in the GitHub repository
- Check the troubleshooting section above
- Refer to [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

**Last Updated**: July 2025  
**Terraform Version**: >= 1.0  
**Azure Provider Version**: Latest stable
