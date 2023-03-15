@description('The kube config for the target Kubernetes cluster.')
@secure()
param kubeConfig string

import 'kubernetes@1.0.0' with {
  kubeConfig: kubeConfig
  namespace: 'default'
}

resource postgresDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: 'postgres'
    labels: {
      app: 'postgres'
    }
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: 'postgres'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'postgres'
        }
      }
      spec: {
        containers: [
          {
            name: 'postgres'
            image: 'postgres:14-alpine'
            imagePullPolicy: 'Always'
            env: [
              {
                name: 'POSTGRES_DB'
                value: 'postgres'
              }
              {
                name: 'POSTGRES_USER'
                value: 'postgres'
              }
              {
                name: 'POSTGRES_PASSWORD'
                value: 'P@ssw0rd'
              }
            ]
          }
        ]
      }
    }
  }
}

resource postgresService 'core/Service@v1' = {
  metadata: {
    name: 'postgres'
    labels: {
      app: 'postgres'
    }
  }
  spec: {
    selector: {
      app: 'postgres'
    }
    ports: [
      {
        port: 5432
        targetPort: 5432
        protocol: 'TCP'
      }
    ]
    type: 'ClusterIP'
  }
}
