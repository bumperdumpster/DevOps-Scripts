### Docker Scaling Group Ubuntu 16.04 ###

## Details

This template is designed to deploy an Azure Scaling Group for Docker Instance

Requires a Microsoft Key Vault setup in Azure.

## Instructions to Prepare for Deploy

The Azure Portal requires the following information, please have it ready before clicking the Deploy to Azure button below.

- Subscription - Subscription Name you would like to deploy the Resource Group to.
- Resource Group - The name of an existing Resource Group or a new one.
- Location - Azure Location of Resource Group - ex. West US
- VM Sku - The size of the VMs - default is Standard_DS1_v2, 1 cpu, 4 GB ram, 128GB persistent disk for Docker
- VMSS Name - Short-name for base naming of resource ex. ctlsupgrp would have resources like ctlsupgrpvnet
- vNetResourceGroup - Name of resource group where vnet is located
- V Net Name -Name of the Virtual network already deployed in the same subcription.
- V NetSubnet Name - Subnet name in the deployed Vnet.
- Instance Count - The number of VMs, a good default is 1 but you can go up to 10, you don't need to do this now you can start with 1 and scale up to 10 later with the click of button from Azure Portal.
- Disk Size - Size of Docker Disk
- Admin Username - Username for the VM instance.
- SSH Public Key (keyvault) - Public Key for the Admin Username to SSH to the box.
- Docker Version - Docker Version to insall.

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

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSC-TechDev%2FDevOps-Scripts%2Fmaster%2Fazure-quickstart-templates%2Fdocker-scaling-group-externallbvnet%2Fazuredeploy.parameters.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
