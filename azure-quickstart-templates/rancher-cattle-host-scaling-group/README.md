### Cattle Hosts Scaling Groups for Rancher Environments on Ubuntu 16.04 ###

## Details

This template is designed to deploy an Azure Scaling Group for a Rancher environment.

Requires a running Rancher Server in Azure with a VNET and a Microsoft Key Vault setup in Azure.

We only need 1 scaling group per environment.  If you decide you need 2 scalings groups make sure you manually setup VPN Peering between the 2 scaling groups.

Also if you have 1 VNET for say infrastructure services then you will need to setup peering manually between that VNET and all VNETs it needs to connect to for say monitoring.

Every Cattle Host has a mount /mnt/cattlestorage to a persistent Azure Storage File Store (cattlestorage) that is Shared between all Cattle Hosts Resource Group.

## Instructions to Prepare for Deploy

The Azure Portal requires the following information, please have it ready before clicking the Deploy to Azure button below.

- Subscription - Subscription Name you would like to deploy the Resource Group to.
- Resource Group - The name of an existing Resource Group or a new one. - rancher-cattle-environment-rg
- Location - Azure Location of Resource Group - ex. West US
- VM Sku - The size of the VMs - default is Standard_DS2_v2, 2 cpu, 7 GB ram, 124GB persistent disk for Docker
- VMSS Name - Short-name for base naming of resource ex. ctlsupgrp would have resources like ctlsupgrpvnet
- Subnet - Subnet for VNET ex. 10.?.0.0/16 Check Rancher Server's VNET/Peerings, there you will find all the peered vnets make sure you don't collide with an existing subnet.
- Instance Count - The number of VMs, a good default is 2 for redundancy but you can go up to 10, you don't need to do this now you can start with 2 and scale up to 10 later with the click of button from Azure Portal.
- Admin Username - Username for the VM instance.
- SSH Public Key - Public Key for the Admin Username to SSH to the box.  By default SSH is behind nat and is typically port 50000-50020. Check the Resource Group's Load Balancer / Inbound NAT rules in Azure to determine correct IP.
- Rancher Url - URI http or https to Rancher Server ex. https://rancher.orgname.com
- Rancher Server Subscription Id - The GUID for the Rancher Server Azure Subscription.
- Rancher Server Resource Group Name - The Resource Group Name for the Rancher Server Resource Group.
- Rancher Server VNET Name - VNET Name for the Rancher Server

## Generating/storing or Locating Rancher API Keys.

If you do not have an Azure key vault you will need to deploy an Azure Key Vault.

Find your Resource Group and Add a new Key Vault resource.

In Advanced access policies Check the options for
- Enable access to Azure Virtual Machines for deployment
- Enable access to Azure Resource Manager for template deployment

You can setup users to access at this time as well if required.

If this is an existing environment then you can open the Key Vault you're using and search the Secrets for the keys for the environment.

If this is a new environment you will need to create new Environment API Keys in Rancher and store them as Secrets in Key Vault.  

https://docs.rancher.com/rancher/v1.0/en/configuration/api-keys/

You can simply navigate to the existing Key Vault and add your new keys.  Please specify the environment in the name of the key ex. CattleEnvironmentAccessKey & CattleEnvironmentSecretKey

Now that you have your API keys you will need to create Secrets in the Azure key vault.

1. Open Resource groups -> Rancher-RG -> rancherKeyVault in Azure Portal.
1. Click on Secrets
1. Click Add button
1. Select Upload options ```Manual```
1. Enter Name.  Naming Convention ```Cattle<environmentname>AccessKey``` or ```Cattle<environmentname>SecretKey``` environmentname is (case-sensitive)
1. Enter Value.
1. Click Create button.

After API keys are input into Azure key vault you'll need to add your environment to the template.

1. Create a new feature branch
1. Edit ```azuredeploy.parameters.json```
1. Add your Rancher environment name (case-sensitive) in the allowed Values array in rancherEnvironment parameter.
1. Save changes
1. Push branch to GitHub
1. Put in Pull Request
1. Once merged your environment will show in the drop-down for environment

If you need help with this email or Slack the DevOps team and they will be happy to assist.

You will need the following information about the Key Vault for Deploy.

- Key Vault Subscription Id - The GUID for the Key Vault Azure Subscription.
- Key Vault Name - The name of the Key Vault
- Key Vault Rancher API Access Key Name - The Secret's name where the Rancher API Access Key is stored.
- Key Vault Rancher API Secret Key Name - The Secret's name where the Rancher API Secret Key is stored.

## Instructions to Deploy

1. Log into Azure https://portal.azure.com
1. Click Deploy to Azure button below.  (This will open Azure to a Deployment Template page.)
1. Fill out the form which is driven by the parameters in the azuredeploy.json with the correct values.  If you have questions about what values to use reach out to folks in DevOps Group.
1. Agree to the EULA by checking the box.
1. Click the Purchase button. YOU WILL BE CHARGED, SO GET THE OKAY!!!
1. After this add a new VPN Peering Connection ```rancherse-to-<vmssName>``` to https://portal.azure.com/#resource/subscriptions/6f7b13dc-a3ff-4e9c-878c-edcc79ecfb9b/resourceGroups/Rancher-RG/providers/Microsoft.Network/virtualNetworks/rancherservervnet/peerings 
1. It takes about 2 minutes for new Hosts to show in Rancher.  They couldn't join until you setup the VPN Peering above.  Normally it takes about the same time to complete the manual step of VPN Peering as it does to ready the host for Rancher.
1. You can now increase and descrease the Scale Set.  Max of 10 VMs! Or log into Rancher Server and see the Hosts Auto Join your Rancher Environment you specified (Takes a 2-3 minutes to complete provisioning)!

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSC-TechDev%2FDevOps-Scripts%2F05bfb3720c06b6c2224547da23803e6e8de17a1d%2Fazure-quickstart-templates%2Francher-cattle-host-scaling-group%2Fazuredeploy.parameters.json target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
