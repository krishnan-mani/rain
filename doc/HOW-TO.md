- Organize your templates for CloudFormation in a folder

```bash
$ mkdir -p examples/templates/s3
```

- Describe the template using a metadata.json file.

```json
{
  "name": "s3",
  "region": "ap-south-1",
  "action": "create"
}
```

- Add the CloudFormation template, name it "template.json"

```json
{
  "Resources": {
    "bucket": {
      "Type": "AWS::S3::Bucket"
    }
  }
}
```

- Create a manifest.yml to list the templates to be processed

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

```
$ tree -L 3 examples/
```
