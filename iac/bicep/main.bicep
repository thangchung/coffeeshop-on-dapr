targetScope = 'subscription'

@minLength(3)
@maxLength(11)
param resourceGroupName string = 'az_oss_rg'

param location string = deployment().location

resource newRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module infra 'infra.bicep' = {
  scope: newRg
  name: 'infra'
  params: {
    location: location
  }
}

module config 'config.bicep' = {
  scope: newRg
  name: 'config'
  dependsOn: [
    infra
  ]
}
