
WIP:
=====
(none)

Pending:
=====
- support .yml format
- retire "hasParameters" directive
- supply a file to log to
- remove obsolete tasks from Rakefile
- add option to validate metadata
- "region" is required at top-level despite defining contexts/environments
- no support for :change_set_create_complete waiter in SDK
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

Testing:
=====
- Do not assign a region within the test
- factor out AWS operations into a provider, use mocking
