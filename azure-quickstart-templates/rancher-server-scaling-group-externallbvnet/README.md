### Rancher Server Scaling Groups for Rancher Environments on Ubuntu 16.04 ###

## Details

This template is designed to deploy an Azure Scaling Group for Rancher Servers

Requires a Microsoft Key Vault setup in Azure.

## Instructions to Prepare for Deploy

The Azure Portal requires the following information, please have it ready before clicking the Deploy to Azure button below.

- Subscription - Subscription Name you would like to deploy the Resource Group to.
- Resource Group - The name of an existing Resource Group or a new one. - rancher-server-rg
- Location - Azure Location of Resource Group - ex. West US
- VM Sku - The size of the VMs - default is Standard_DS2_v2, 2 cpu, 7 GB ram, 128GB persistent disk for Docker
- VMSS Name - Short-name for base naming of resource ex. ctlsupgrp would have resources like ctlsupgrpvnet
- V Net Name -Name of the Virtual network already deployed in the same subcription.
- V NetSubnet Name - Subnet name in the deployed Vnet.
- Load Balancer Name - Name of the deployed load balancer in same subcription and the location where you want VMSS to be connected to.
- Be pool Name - back end pool name of the load balancer.
- Nat pool Name - Nat pool Name of the load balancer.
- Instance Count - The number of VMs, a good default is 3 for Rancher HA but you can go up to 10, you don't need to do this now you can start with 3 and scale up to 10 later with the click of button from Azure Portal.
- Admin Username - Username for the VM instance.
- SSH Public Key (keyvault) - Public Key for the Admin Username to SSH to the box.  By default SSH is behind nat and is typically port 50000-50020. Check the Resource Group's Load Balancer / Inbound NAT rules in Azure to determine correct IP.
- Encryption Key (keyvault) - Encryption Key for Rancher Server
- DB Host - DB Hostname or IP
- DB Port - DB Host Port
- DB Name - DB Name of DB in DB Host
- DB User - Database user used to access DB in DB Name
- DB Pass (keyvault) - Password for DB User
- Key Vault Subscription ID - Subscription ID where Azure Key Vault exists
- Key Vault Resource Group Name - Resource Group Name where Azure Key Vault exists

## Generating/storing Key Vault keys required for deployment

You'll need to create the following keys and upload their secrets in the Azure Key Vault you'll be specifing at Deploy time

SSH Key (name can be specified)

RancherServerEncryptionKey, RancherServerDbPassword (names must be exact)

## Instructions to Deploy

1. Log into Azure https://portal.azure.com
1. Click Deploy to Azure button below.  (This will open Azure to a Deployment Template page.)
1. Fill out the form which is driven by the parameters in the azuredeploy.json with the correct values.  If you have questions about what values to use reach out to folks in DevOps Group.
1. Agree to the EULA by checking the box.
1. Click the Purchase button. YOU WILL BE CHARGED, SO GET THE OKAY!!!
1. You can now increase and descrease the Scale Set.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSC-TechDev%2FDevOps-Scripts%2Fmaster%2Fazure-quickstart-templates%2Francher-server-scaling-group-externallbvnet%2Fazuredeploy.parameters.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
