### Pre-requisites

- ruby
- (optional) using (https://rvm.io)[rvm]

```bash
$ rvm use --create 2.3.1@rain
$ bundle install --binstubs
```

- Run spec tests

```
$ rspec
```

- Run rain

```
$ ./rain.rb -h
$ ./rain.rb -d /path/to/manifest/and/templates
```
