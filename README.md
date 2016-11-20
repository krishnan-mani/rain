
- Getting started: (doc/getting-started.md)["doc/getting-started.md"]
- Terminology: (doc/terminology.md)["doc/terminology.md"]

### Features

- Process any number of templates to create and maintain multiple stacks
- For each template, create one stack, or multiple stacks identified by "context" and by "environment" from a single template
  - A "context" is an instance of a stack (with its own parameters and behaviour). For e.g., a stack that is used to manage a DNS domain can be re-used with multiple DNS domains, each represented by a "context"
  - An "environment" is also an instance of a stack (with its own parameters and behaviour). For e.g., a "dev", "qa", and "live" environments
- The entire set of actions on stacks in CloudFormation over the life-cycle of a stack, including:
  - 'create-stack', 'update-stack', 'create-change-set', and 'delete-stack'
- Utility features:
  - upload template to S3
  - discover and supply capabilities required for a stack in CloudFormation
  
### Conventions in use

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

### Notes

- The conventions and terminology (such as "contexts", "environments", and "action") are specific to rain, and are not required by CloudFormation.
- Similarly, the use of a metadata file ("metadata.json") to describe a template, and a manifest ("manifest.yml") to list templates to be processed is specific to rain, and is not recognised by or required by CloudFormation.
