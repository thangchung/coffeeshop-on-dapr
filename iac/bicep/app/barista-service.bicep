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

resource baristaServiceDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'baristaservice'
    labels: {
      app: 'baristaservice'
    }
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: 'baristaservice'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'baristaservice'
        }
        annotations: {
          'dapr.io/enabled': 'true'
          'dapr.io/app-id': 'baristaservice'
          'dapr.io/app-port': '5003'
        }
      }
      spec: {
        containers: [
          {
            name: 'baristaservice'
            image: '${containerRegistry}/barista-service:${containerTag}'
            imagePullPolicy: 'Always'
            env: [
              {
                name: 'ASPNETCORE_ENVIRONMENT'
                value: 'Development'
              }
              {
                name: 'ConnectionStrings__baristadb'
                value: 'Server=postgres;Port=5432;Database=postgres;User Id=postgres;Password=P@ssw0rd'
              }
              {
                name: 'SERVICEBUS_CONNECTIONSTRING'
                valueFrom: {
                  secretKeyRef: {
                    name: 'servicebus'
                    key: 'connectionString'
                  }
                }
              }
            ]
          }
        ]
      }
    }
  }
}
