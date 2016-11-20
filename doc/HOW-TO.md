
- Describe each template using a metadata.json file.

```json
{
  "name": "def",
  "hasParameters": true,
  "contexts": {
    "xyz": {
      "region": "ap-south-1",
      "action": "create"
    }
  },
  "environments": {
    "pqr": {
      "region": "ap-south-1",
      "action": "create"
    }
  }
}
```

- Describe a list of templates to be processed using a manifest.yml file

```yml
path: evolution
templates:
  - public-domain-dns
  - s3:
      contexts:
        - logs-bucket
        - artifacts-bucket
  - app-01-environments:
      environments:
        - development
        - qa
```
