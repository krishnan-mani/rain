### Features

- Process any number of CloudFormation templates to create and maintain multiple CloudFormation stacks across AWS regions
- Support the entire set of life-cycle actions on stacks in CloudFormation, including:
  - 'create-stack', 'update-stack', 'create-change-set', and 'delete-stack'
- For each template, maintain one stack, or multiple stacks identified by "contexts" and/or by "environments", all from a single template
  - A stack may be provisioned from a single template independently of other stacks that use the same template. For e.g., a stack used to manage a DNS domain can be re-used to manage multiple DNS domains (that may or may not be related to each other), and therefore, each such stack has "context".
  - A stack that is provisioned from a single template for the use of a specific application scenario may be replicated in various environments for the application. For e.g., stacks for ```dev```, ```qa```, and ```live``` "environments" for an application.
- Utility features:
  - upload template to S3
  - discover and supply capabilities required for a stack in CloudFormation, etc.
