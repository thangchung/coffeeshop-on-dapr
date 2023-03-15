@description('Azure region to deploy resources into. Defaults to location of target resource group')
param location string = resourceGroup().location

@description('Name of the container registry. Defaults to unique hashed ID prefixed with "coffeeshop"')
param registryName string = 'coffeeshop${uniqueString(resourceGroup().id)}'

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: registryName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    anonymousPullEnabled: true
  }
}

output registryId string = acr.id
