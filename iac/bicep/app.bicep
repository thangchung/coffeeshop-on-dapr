// Application -----------------------------------------

@description('Name of the container registry. Defaults to unique hashed ID prefixed with "coffeeshop"')
param registryName string = 'coffeeshop${uniqueString(resourceGroup().id)}'

@description('Name of the AKS cluster. Defaults to a unique hash prefixed with "coffeeshop-"')
param clusterName string = 'coffeeshop'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: registryName
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' existing = {
  name: clusterName
}

module postgres 'app/postgres.bicep' = {
  name: 'postgres'
  params: {
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}

module reverseproxy 'app/reverse-proxy.bicep' = {
  name: 'reverseproxy'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}

module productservice 'app/product-service.bicep' = {
  name: 'productservice'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}

module counterservice 'app/counter-service.bicep' = {
  name: 'counterservice'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}

module baristaservice 'app/barista-service.bicep' = {
  name: 'baristaservice'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}

module kitchenservice 'app/kitchen-service.bicep' = {
  name: 'kitchenservice'
  params: {
    containerRegistry: containerRegistry.properties.loginServer
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}

module ingress 'app/ingress.bicep' = {
  name: 'ingress'
  params: {
    HTTPApplicationRoutingZoneName: aksCluster.properties.addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName
    kubeConfig: aksCluster.listClusterAdminCredential().kubeconfigs[0].value
  }
}
