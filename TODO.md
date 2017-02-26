
WIP:

- supply only specified capabilities
- factor out AWS operations into a provider, use mocking

Pending: 

- add option to validate metadata
- retire "hasParameters" directive
- refactor
- create gem
- list pending change sets (WIP)
- region override
- support nested stacks
- sync template from current stack
- support update policy for contexts and environments, in the most general case
- add init and configuration mechanism
- configure notifications
- Handle stack updates error: Aws::CloudFormation::Errors::ValidationError: No updates are to be performed
- add :client_token for idempotence (use commit hash?)
- accept either JSON or YAML formats

Testing:

- Do not assign a region within the test
- factor out AWS operations into a provider, use mocking
