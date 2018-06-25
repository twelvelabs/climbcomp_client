# ClimbcompClient

[![Build Status](https://travis-ci.com/twelvelabs/climbcomp_client.svg)](https://travis-ci.com/twelvelabs/climbcomp_client)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/climbcomp_client`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'climbcomp_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install climbcomp_client

## Usage

TODO: Write usage instructions here

## Development

```bash
# Checkout and setup the repo.
git clone git@github.com:twelvelabs/climbcomp_client.git
cd ./climbcomp_client
cp .env.example .env

# Build the docker image and startup bash in a container.
# Note: `--service-ports` is required so that port 3001 is properly setup for token authentication.
docker-compose build
docker-compose run --rm --service-ports app bash

# Running tests:
bash-4.4# rake test
# irb console:
bash-4.4# ./bin/console
# Interact with the CLI:
bash-4.4# ./exe/climbcomp help
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/climbcomp_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the ClimbcompClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/climbcomp_client/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2018 Skip Baney. See [MIT License](LICENSE) for further details.