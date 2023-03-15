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

resource reverseProxyDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'reverseproxy'
    labels: {
      app: 'reverseproxy'
    }
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: 'reverseproxy'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'reverseproxy'
        }
        annotations: {
          'dapr.io/enabled': 'true'
          'dapr.io/app-id': 'reverseproxy'
          'dapr.io/app-port': '8080'
        }
      }
      spec: {
        containers: [
          {
            name: 'reverseproxy'
            image: '${containerRegistry}/reverse-proxy:${containerTag}'
            imagePullPolicy: 'Always'
            env: [
              {
                name: 'ASPNETCORE_ENVIRONMENT'
                value: 'Development'
              }
              {
                name: 'ReverseProxy__Clusters__productApiCluster__Destinations__destination1__Address'
                value: 'http://productservice:5001'
              }
              {
                name: 'ReverseProxy__Clusters__counterApiCluster__Destinations__destination1__Address'
                value: 'http://counterservice:5002'
              }
            ]
          }
        ]
      }
    }
  }
}

resource reverseProxyService 'core/Service@v1' = {
  metadata: {
    name: 'reverseproxy'
    labels: {
      app: 'reverseproxy'
    }
  }
  spec: {
    selector: {
      app: 'reverseproxy'
    }
    ports: [
      {
        port: 80
        targetPort: 8080
        protocol: 'TCP'
      }
    ]
    type: 'ClusterIP'
  }
}
