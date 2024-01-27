# Create Local Image Streams

```bash
oc new-project dev-tools
oc policy add-role-to-group system:image-puller system:serviceaccounts -n dev-tools
oc import-image ubi-minimal:latest --from=registry.access.redhat.com/ubi9/ubi-minimal --confirm -n dev-tools
```
