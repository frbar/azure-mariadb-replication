# Purpose

Bicep template to deploy a Maria DB instance and create a read replica in another region.

# Deploy the infrastructure

```powershell
$subscription = "Training Subscription"

az login
az account set --subscription $subscription

$rgName = "frbar-mariadb-repl-poc"
$envName = "frbarreplpoc"
$location = "France Central"
$replicaLocation = "France South"

az group create --name $rgName --location $location
az deployment group create --resource-group $rgName --template-file infra.bicep --mode complete --parameters envName=$envName replicaLocation=$replicaLocation
```

# Tear down

```powershell
az group delete --name $rgName
```
