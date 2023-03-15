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

resource kitchenServiceDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'kitchenservice'
    labels: {
      app: 'kitchenservice'
    }
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: 'kitchenservice'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'kitchenservice'
        }
        annotations: {
          'dapr.io/enabled': 'true'
          'dapr.io/app-id': 'kitchenservice'
          'dapr.io/app-port': '5004'
        }
      }
      spec: {
        containers: [
          {
            name: 'kitchenservice'
            image: '${containerRegistry}/kitchen-service:${containerTag}'
            imagePullPolicy: 'Always'
            env: [
              {
                name: 'ASPNETCORE_ENVIRONMENT'
                value: 'Development'
              }
              {
                name: 'ConnectionStrings__kitchendb'
                value: 'Server=postgres;Port=5432;Database=postgres;User Id=postgres;Password=P@ssw0rd'
              }
            ]
          }
        ]
      }
    }
  }
}
