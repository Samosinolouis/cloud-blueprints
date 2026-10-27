@description('Primary deployment region')
param location string = resourceGroup().location

@description('Unique short prefix for the storage account')
@minLength(3)
@maxLength(8)
param prefix string = 'bpstore'

// Generate a deterministic 24-character globally unique name
var storageAccountName = toLower('${prefix}${uniqueString(resourceGroup().id)}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: 'secure-data'
  properties: {
    publicAccess: 'None'
  }
}

output deployedStorageAccountName string = storageAccount.name
