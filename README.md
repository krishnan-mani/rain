### Features

- Process any number of CloudFormation templates to create and maintain multiple CloudFormation stacks across AWS regions (templates are listed in a manifest)
- Support the entire set of life-cycle actions on stacks in CloudFormation, including:
  - 'create-stack', 'update-stack', 'create-change-set', and 'delete-stack'
- For each template, maintain one stack, or multiple stacks identified by "contexts" and/or by "environments", all from a single template
  - A "context" is a stack with its own set of parameters. For e.g., a template used to create and manage a stack for a DNS domain can be re-used for multiple DNS domains, each identified by a separate "context".
  - An "environment" is an instance of a stack with its own parameters. For e.g., stacks for "dev", "qa", and "live" environments for an application in Elastic Beanstalk.
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

### Watch me!

- Getting started

![Getting started](/doc/getting-started-asciicast.gif)

### Coming soon...

- gem for use as a library
- support for stack policy
- [And more ...](TODO.md)

### About

- [Install](doc/install.md)
- [HOW-TO](doc/HOW-TO.md)
- [Terminology](doc/terminology.md)
