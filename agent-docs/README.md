# Agent Docs Server Helm Chart

Helm chart for deploying the Agent Docs MCP http_server. Includes secure defaults and configurable writable storage for documentation ingestion.

## Quick Start

- Default deploy (ephemeral scratch using `emptyDir` at `/tmp`):

  helm upgrade --install agent-docs docs/charts/agent-docs \
    -n agent-docs --create-namespace \
    --set env.DATABASE_URL=postgres://user:pass@host:5432/dbname

This mounts a writable `emptyDir` at `/tmp` and sets `INGEST_WORK_DIR=/tmp` for ingestion jobs.

## Persistence Options

By default the container uses a read-only root filesystem. Ingestion needs a writable work directory for git clones and temp files. You have two options:

1) Ephemeral (default)
- `emptyDir` mounted at `/tmp`
- `env.INGEST_WORK_DIR` set to `/tmp`
- Cleared on pod restart/eviction

2) Persistent Volume (PVC)
- Enable and configure in `values.yaml`:

  persistence:
    enabled: true
    storageClassName: "local-path"   # or your class
    size: 20Gi                        # adjust as needed
    mountPath: "/work"               # becomes INGEST_WORK_DIR
    accessModes:
      - ReadWriteOnce
    existingClaim: ""                 # optional pre-created PVC name

- The chart will:
  - Create a PVC (unless `existingClaim` is set)
  - Mount it at `persistence.mountPath`
  - Set `INGEST_WORK_DIR` to the mount path

## Key Values

- env.DATABASE_URL: Postgres connection string (required)
- env.OPENAI_API_KEY: API key if using embeddings (optional)
- env.RUST_LOG: log level (default `info,doc_server=debug`)
- env.PORT: server port (default `3001`)
- env.MCP_HOST: bind address (default `0.0.0.0`)
- env.INGEST_WORK_DIR: Base writable dir for ingestion temp files (auto-set by chart)

### Persistence block

- persistence.enabled: Enable PVC-backed work directory
- persistence.existingClaim: Use existing PVC name (skip creation)
- persistence.mountPath: Mount path inside container (used for `INGEST_WORK_DIR`)
- persistence.size: PVC size (e.g., 10Gi)
- persistence.storageClassName: Storage class (e.g., `local-path`)
- persistence.accessModes: Access modes (default `[ReadWriteOnce]`)

## Security

- `readOnlyRootFilesystem: true` by default
- A writable volume is mounted only at the work directory path (`/tmp` or your `mountPath`)
- Drops all capabilities and disables privilege escalation by default

## Notes

- The ingestion pipeline spawns a local loader process in the same pod, using `INGEST_WORK_DIR` for temp state.
- If you run multiple replicas, ingest job status is persisted in the database and can be queried from any replica.

