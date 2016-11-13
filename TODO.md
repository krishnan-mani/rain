- list all change sets

- support custom manifest
- support listed environments and contexts in manifest
- support update policy for contexts and environments
- support nested stack

- add init and configuration mechanism
- configure notifications
- Handle stack updates error: Aws::CloudFormation::Errors::ValidationError: No updates are to be performed
- add :client_token for idempotence (use commit hash)
- generate parameter information
- accept either JSON or YAML formats
- factor out AWS operations into a provider, use mocking
