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
$ rvm use 2.3.1@rain
$ ./rain.rb -h
Usage: rain.rb [options]
    -p, --path PATH                  (REQUIRED) Specify a filesystem path to the template artifacts
    -f, --file manifest-file         Specify a manifest file
    -b, --s3-bucket bucket           Specify an S3 bucket and S3 region
    -r, --s3-region region           Specify an S3 bucket and S3 region
    -h, --help                       Display help
$ ./rain.rb -p /path/to/folder/containing/templates/and/manifest
```
- Add more templates, and enumerate the ones to be processed in the manifest

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
