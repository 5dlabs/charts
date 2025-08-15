# Agent Docs Chart

A Helm chart for the Agent Docs service.

## Installation

```bash
helm install agent-docs ./helm/agent-docs
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `nginx` |
| `image.tag` | Container image tag | `alpine` |
| `image.pullPolicy` | Container image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Kubernetes service port | `80` |
| `ingress.enabled` | Enable ingress | `false` |
| `resources` | CPU/Memory resource requests/limits | `{}` |
| `home.title` | Home page title | `Agent Docs` |
| `home.subtitle` | Home page subtitle | `Documentation and API Reference` |
| `home.description` | Home page description | `Welcome to the Agent Documentation Service` |

## Usage

This chart deploys a simple nginx-based home page for the Agent Docs service. The home page content is configurable through the `content.html` value in `values.yaml`.

### Customizing the Home Page

You can customize the home page by modifying the `content.html` section in `values.yaml`:

```yaml
content:
  html: |
    <!DOCTYPE html>
    <html>
    <head>
        <title>My Custom Title</title>
    </head>
    <body>
        <h1>Welcome to My Service</h1>
        <p>This is a custom home page.</p>
    </body>
    </html>
```

### Enabling Ingress

To enable ingress, set `ingress.enabled` to `true` and configure the ingress settings:

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: agent-docs.example.com
      paths:
        - path: /
          pathType: Prefix
```
