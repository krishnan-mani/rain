
- Some conventions and terminology (such as "contexts", "environments", and "action") are specific to rain, and are not required by CloudFormation.
- Similarly, the use of a metadata file ("metadata.json") to describe a template, and a manifest ("manifest.yml") to list templates to be processed is specific to rain, and is not recognised by or required by CloudFormation.

### Terms

- manifest: A listing of the templates to be processed
- metadata: A description of the template to be able to create stacks, including information such as the stack name, AWS region, etc.
- stack action: One of "create", "update", and "recreate" that indicates the action to be performed on corresponding stacks
- context: Each template can be used to create multiple (possibly unrelated) stacks, each stack identified by a "context". For e.g., a template to create a hosted zone in Route 53 for a DNS domain, can be re-used to create multiple stacks by "context", each corresponding to a different domain
- environment: Each template can be used to create multiple (related) stacks, each stack identified by an "environment". For e.g., a template to create an Elastic Beanstalk environment for an app, can be re-used to create "dev", "qa", and "live" stacks, each corresponding to an environment
