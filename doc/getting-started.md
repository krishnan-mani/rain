### Pre-requisites

- ruby
- (optional) using [rvm](https://rvm.io)

```bash
$ rvm use --create 2.4.1@rain
$ gem install bundler --no-ri --no-rdoc
$ bundle install --binstubs
```

### Running

- Run spec tests

```bash
# Provide credentials for your AWS account
$ export AWS_PROFILE=me@account
$ rspec
```

- Run rain

```bash
# Provide credentials for your AWS account
$ export AWS_PROFILE=me@account
$ ./rain.rb -h
$ ./rain.rb -d /path/to/manifest/and/templates
```
