- Organize your templates for CloudFormation in a folder

```bash
$ mkdir -p examples/my_templates/s3
```
- Describe the template using a 'metadata.json' file.

```json
{
  "name": "s3",
  "region": "ap-south-1",
  "action": "create"
}
```

- Add the CloudFormation template, name it 'template.json'

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
path: my_templates
templates:
  - s3
```
```bash
$ tree -L 3 examples/
examples/
├── manifest.yml
└── my_templates
    └── s3
        ├── metadata.json
        └── template.json

2 directories, 3 files
```
- Process the templates using 'rain'

```bash
$ ./rain.rb -d /path/to/folder/containing/templates/and/manifest
```
- Add more templates, and enumerate the ones to be processed

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
