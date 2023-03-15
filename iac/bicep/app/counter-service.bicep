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

resource counterServiceDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'counterservice'
    labels: {
      app: 'counterservice'
    }
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: 'counterservice'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'counterservice'
        }
        annotations: {
          'dapr.io/enabled': 'true'
          'dapr.io/app-id': 'counterservice'
          'dapr.io/app-port': '5002'
        }
      }
      spec: {
        containers: [
          {
            name: 'counterservice'
            image: '${containerRegistry}/counter-service:${containerTag}'
            imagePullPolicy: 'Always'
            env: [
              {
                name: 'ASPNETCORE_ENVIRONMENT'
                value: 'Development'
              }
              {
                name: 'ConnectionStrings__counterdb'
                value: 'Server=postgres;Port=5432;Database=postgres;User Id=postgres;Password=P@ssw0rd'
              }
            ]
          }
        ]
      }
    }
  }
}

resource counterService 'core/Service@v1' = {
  metadata: {
    name: 'counterservice'
    labels: {
      app: 'counterservice'
    }
  }
  spec: {
    selector: {
      app: 'counterservice'
    }
    ports: [
      {
        port: 5002
        targetPort: 5002
        protocol: 'TCP'
      }
    ]
    type: 'ClusterIP'
  }
}
