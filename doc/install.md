- You can use [rvm](https://rvm.io) 

```
$ rvm use --create 2.3.1@rain
$ bundle install --binstubs
$ ./rain.rb -h # Help instructions
```

- Run the tests

```
$ export AWS_PROFILE=me@account
$ rspec -f d # Print test description
```
- Run rain on a number of templates

```
$ ./rain.rb -p /path/to/manifest.yml
```
