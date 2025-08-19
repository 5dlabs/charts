# Jupiter Swap API Helm Chart

A Helm chart for deploying the Jupiter V6 Swap API in Kubernetes.

## Overview

Jupiter is the leading DEX aggregator on Solana, providing the best swap rates across all DEXs and AMMs. This chart deploys the Jupiter Swap API which allows you to self-host the Jupiter API for your applications.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Access to a container registry (if using custom images)
- Docker (for building the image)

## Building the Docker Image

Jupiter doesn't provide official Docker images, so you need to build your own:

```bash
# Clone the repository
git clone https://github.com/jup-ag/jupiter-swap-api.git
cd jupiter-swap-api

# Build the image
docker build -t your-registry/jupiter-swap-api:v6.0.62 .

# Push to your registry
docker push your-registry/jupiter-swap-api:v6.0.62
```

Alternatively, you can build directly from the GitHub repository:

```bash
docker build -t your-registry/jupiter-swap-api:v6.0.62 https://github.com/jup-ag/jupiter-swap-api.git
```

## Installation

### Basic Installation

```bash
helm install jupiter-swap-api ./jupiter
```

### With Custom Values

```bash
helm install jupiter-swap-api ./jupiter \
  --set image.repository=your-registry/jupiter-swap-api \
  --set image.tag=v6.0.62 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=jupiter.yourdomain.com
```

## Configuration

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `your-registry/jupiter-swap-api` |
| `image.tag` | Container image tag | `v6.0.62` |
| `image.pullPolicy` | Container image pull policy | `Always` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `8080` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `alb` |
| `ingress.hosts` | Ingress hosts configuration | `jupiter-swap-api.local` |

### Resource Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.cpu` | CPU limits | `1000m` |
| `resources.limits.memory` | Memory limits | `1Gi` |
| `resources.requests.cpu` | CPU requests | `500m` |
| `resources.requests.memory` | Memory requests | `512Mi` |

### Health Checks

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.path` | Liveness probe path | `/v6/health` |
| `readinessProbe.path` | Readiness probe path | `/v6/health` |

### Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env.RUST_LOG` | Log level | `info` |

## API Endpoints

Once deployed, the following endpoints will be available:

- **Health Check**: `GET /v6/health`
- **Quote**: `GET /v6/quote`
- **Swap**: `POST /v6/swap`
- **Price**: `GET /v6/price`

## Usage Examples

### Get a Quote

```bash
curl "http://your-jupiter-api/v6/quote?inputMint=So11111111111111111111111111111111111111112&outputMint=EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v&amount=1000000&slippageBps=50"
```

### Get Price

```bash
curl "http://your-jupiter-api/v6/price?ids=So11111111111111111111111111111111111111112,EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"
```

## Monitoring

### Health Check

```bash
kubectl exec deployment/jupiter-swap-api -- curl -s http://localhost:8080/v6/health
```

### View Logs

```bash
kubectl logs deployment/jupiter-swap-api
```

## Troubleshooting

### Common Issues

1. **Image Pull Errors**: Ensure you have access to the container registry and the image exists
2. **Health Check Failures**: Verify the API is responding on the health endpoint
3. **Resource Constraints**: Adjust CPU/memory limits if the pod is being killed

### Debug Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=jupiter-swap-api

# Describe pod for more details
kubectl describe pod <pod-name>

# Check service
kubectl get svc -l app.kubernetes.io/name=jupiter-swap-api

# Port forward for local testing
kubectl port-forward svc/jupiter-swap-api 8080:8080
```

## Upgrading

```bash
helm upgrade jupiter-swap-api ./jupiter
```

## Uninstalling

```bash
helm uninstall jupiter-swap-api
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `helm lint` and `helm template`
5. Submit a pull request

## References

- [Jupiter Documentation](https://station.jup.ag/docs/apis/self-hosted)
- [Jupiter GitHub Repository](https://github.com/jup-ag/jupiter-swap-api)
- [Jupiter Telegram Updates](https://t.me/jup_dev)
