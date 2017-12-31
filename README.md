
### Watch me!

- Getting started

![Getting started](/doc/getting-started-asciicast.gif)


### Features

- Process any number of CloudFormation templates to create and maintain multiple CloudFormation stacks across AWS regions (templates are listed in a manifest)
- Support the entire set of life-cycle actions on stacks in CloudFormation, including:
  - 'create-stack', 'update-stack', 'create-change-set', and 'delete-stack'
- For each template, maintain one stack, or multiple stacks identified by "contexts" and/or by "environments", all from a single template, each with its own set of parameters, etc.
  - A stack may be provisioned from a single template independently of other stacks that use the same template. For e.g., a stack used to manage a DNS domain can be re-used to manage multiple DNS domains (that may or may not be related to each other), and therefore, each such stack has "context".
  - A stack that is provisioned from a single template for the use of a specific application scenario may be replicated in various environments for the application. For e.g., stacks for ```dev```, ```qa```, and ```live``` "environments" for an application.
  - Uses a consistent naming convention to map from templates to stacks
  - Support "create", "update", and "recreate" actions for a stack:
    - "create": Create a stack if one does not exist, else create a change-set against the stack
    - "update": Create a stack if one does not exist, else update the stack
    - "recreate": Delete any existing stack, then create
- Utility features:
  - upload template to S3
  - discover and supply capabilities required for a stack in CloudFormation, etc.
  - inspect a template and generate a "stub" file for Parameters to be populated with the values (includes the default values for any Parameters for reference)
  - specify the ```--on-failure``` action when creating a stack

### Coming soon...

- gem for use as a library
- support for stack policy
- [And more ...](TODO.md)

### About

- [Install](doc/install.md)
- [HOW-TO](doc/HOW-TO.md)
- [Terminology](doc/terminology.md)
