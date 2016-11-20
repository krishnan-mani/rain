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
