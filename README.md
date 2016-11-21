### Features

- Process any number of CloudFormation templates to create and maintain multiple CloudFormation stacks across AWS regions
- Support the entire set of life-cycle actions on stacks in CloudFormation, including:
  - 'create-stack', 'update-stack', 'create-change-set', and 'delete-stack'
- For each template, maintain one stack, or multiple stacks identified by "contexts" and/or by "environments", all from a single template
  - A "context" is a stack with its own parameters and behaviour. For e.g., a stack used to manage a DNS domain can be re-used with multiple DNS domains, each identified by an independent "context".
  - An "environment" is an instance of a stack with its own parameters and behaviour. For e.g., stacks for "dev", "qa", and "live" environments for an application in Elastic Beanstalk.
- Utility features:
  - upload template to S3
  - discover and supply capabilities required for a stack in CloudFormation, etc.

### Watch me!

![Getting started](/doc/getting-started-asciicast.gif)

### Coming soon

- gem for use as a library
- support for stack policy
- [And more ...](TODO.md)

### About

- [HOW-TO](doc/HOW-TO.md)
- [Terminology](doc/terminology.md)
