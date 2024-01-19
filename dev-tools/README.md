# Create Local Image Streams

```bash
oc new-project dev-images
oc policy add-role-to-group system:image-puller system:serviceaccounts -n dev-images
oc import-image ubi-minimal:latest --from=registry.access.redhat.com/ubi9/ubi-minimal --confirm -n dev-images
```
