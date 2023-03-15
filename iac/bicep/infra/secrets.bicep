@description('The kube config for the target Kubernetes cluster.')
@secure()
param kubeConfig string

@description('Service Bus Authorization Rule connection string')
@secure()
param serviceBusConnectionString string

import 'kubernetes@1.0.0' with {
  kubeConfig: kubeConfig
  namespace: 'default'
}

resource serviceBusSecret 'core/Secret@v1' = {
  metadata: {
    name: 'servicebus'
  }
  stringData: {
    connectionString: serviceBusConnectionString
  }
}
