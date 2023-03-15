@description('The kube config for the target Kubernetes cluster.')
@secure()
param kubeConfig string

@description('Address of the container registry where container resides')
param containerRegistry string

@description('Tag of container to use')
param containerTag string = 'latest'

import 'kubernetes@1.0.0' with {
  kubeConfig: kubeConfig
  namespace: 'default'
}

resource productServiceDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'productservice'
    labels: {
      app: 'productservice'
    }
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: 'productservice'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'productservice'
        }
        annotations: {
          'dapr.io/enabled': 'true'
          'dapr.io/app-id': 'productservice'
          'dapr.io/app-port': '5001'
        }
      }
      spec: {
        containers: [
          {
            name: 'productservice'
            image: '${containerRegistry}/product-service:${containerTag}'
            imagePullPolicy: 'Always'
            env: [
              {
                name: 'ASPNETCORE_ENVIRONMENT'
                value: 'Development'
              }
            ]
          }
        ]
      }
    }
  }
}
