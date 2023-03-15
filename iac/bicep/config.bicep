@description('Name of the AKS cluster. Defaults to a unique hash prefixed with "coffeeshop-"')
param clusterName string = 'coffeeshop'

@description('Azure Service Bus authorization rule name')
param serviceBusAuthorizationRuleName string = 'coffeeshop-${uniqueString(resourceGroup().id)}/Dapr'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' existing = {
  name: clusterName
}

resource serviceBusAuthorizationRule 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-01-01-preview' existing = {
  name: serviceBusAuthorizationRuleName
}

module secrets 'infra/secrets.bicep' = {
  name: 'secrets'
  params: {
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
    serviceBusConnectionString: serviceBusAuthorizationRule.listKeys().primaryConnectionString
  }
}
