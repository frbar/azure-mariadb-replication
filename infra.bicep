targetScope = 'resourceGroup'

@description('Environment name, will be used to prefix resources')
param envName string

@description('Azure region for the read replica')
param replicaLocation string

@description('Database administrator password')
@minLength(8)
@secure()
param administratorLoginPassword string

@description('Azure database for MariaDB compute capacity in vCores (2,4,8,16,32)')
param skuCapacity int = 2

@description('Azure database for MariaDB sku name ')
param skuName string = 'GP_Gen5_2'

@description('Azure database for MariaDB Sku Size ')
param skuSizeMB int = 51200

@description('Azure database for MariaDB pricing tier')
param skuTier string = 'GeneralPurpose'

@description('Azure database for MariaDB sku family')
param skuFamily string = 'Gen5'

@description('MariaDB version')
@allowed([
  '10.2'
  '10.3'
])
param mariadbVersion string = '10.3'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('MariaDB Server backup retention days')
param backupRetentionDays int = 7

@description('Geo-Redundant Backup setting')
param geoRedundantBackup string = 'Enabled'

resource mariaDbServer 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: '${envName}srv1'
  location: location
  sku: {
    name: skuName
    tier: skuTier
    capacity: skuCapacity
    size: '${skuSizeMB}' //a string is expected here but a int for the storageProfile...
    family: skuFamily
  }
  properties: {
    createMode: 'Default'
    version: mariadbVersion
    administratorLogin: 'admMaria38'
    administratorLoginPassword: administratorLoginPassword
    storageProfile: {
      storageMB: skuSizeMB
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
  }
}

resource mariaDbServerReplica 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: '${envName}replica'
  location: replicaLocation
  sku: {
    name: skuName
    tier: skuTier
    capacity: skuCapacity
    size: '${skuSizeMB}' //a string is expected here but a int for the storageProfile...
    family: skuFamily
  }
  properties: {
    createMode: 'Replica'
    sourceServerId: mariaDbServer.id
  }
}
