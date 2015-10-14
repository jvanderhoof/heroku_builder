# Heroku Builder

Heroku Builder allows for straight forward configuration of your multi (or single) stage Heroku application as well as dead simple deployment.  It uses a YAML configuration to manage a multi-environment configuration, including: configuration variables, resources, add-ons, and git based deployment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku_builder

## Usage

### Getting Started

To get started, generate a new configuration file:

    $ rake builder:init

This will place a file `config/heroku.yml with some basic configuration options. You'll want update the configuration files as you see fit for your particular setup.  The configuration file is the meat of this tool, so let's take a look at what we can do with it.

### Configuration

When you open `config/heroku.yml`, you'll see something like this:

```yaml
staging:
  app:
    name: my-heroku-app-name-staging
    git_repo: git@github.com:foo/my-heroku-app-name
    git_branch: staging
  config_vars: []
  addons: []
  resources:
    web:
      count: 1
      type: Free
production:
  app:
    name: my-heroku-app-name
    git_repo: git@github.com:foo/my-heroku-app-name
    git_branch: master
  config_vars: []
  addons: []
  resources:
    web:
      count: 1
      type: Free

```

Let's start from the outside and work our way in.

`staging` and `production` are references to the environments you maintain for a particular application.  You can add as many of these as you'd like.  These environments also determine the environment a Rake task targets.  For example:

    $ rake builder:staging:apply

Would apply the configuration for the `staging` environment.

The `app` sections provides settings particular to the application.
* `name` - the Heroku application name.  The application will be created unless it already exists on Heroku.
* `git_repo` - the repository the project code is kept in.  Code will be checked out from this repository as part of the deploy process, so you'll need at least read permission on the repo to deploy code to Heroku.
* `git_branch` - the branch of the `git_repo` repo that you wish to deploy from.

The `config_vars` setting allows you to set Config Vars for a particular environment.  These can be applied as follows:

```yaml
config_vars:
  FOO: bar
  BAZ: <%= ENV['BAZ'] %>
```

Variables can be set with either a string or ERB tags.  ERB tags allow sensitive information to be kept out of code that is committed.  It's important to know that Heroku Builder only adds or updates variables that are defined in the configuration. Variables that are set in the Heroku console, but not defined in your configuration will not be removed.

The `addons` section allows you to define the Add-ons for a particular application. Add-ons are defined as an array:

```yaml
  addons:
    - papertrail
    - heroku-postgresql:hobby-dev
    - heroku-redis:hobby-dev
    - scheduler:standard
```

As with other sections, be aware that removing add-on items will not cause them to be deleted from Heroku.  Removing add-ons should be handled through the Heroku Dashboard.

The `resources` section allows a user to define the resource types and counts.  An example of a resource section for a side project might look like:

```yaml
resources:
    web:
      count: 1
      type: Free
    worker:
      count: 1
      type: Free
```

For a production website, it might look more like:
```yaml
resources:
    web:
      count: 8
      type: 2X
    worker:
      count: 4
      type: 1X
```

### Heroku API Key

Heroku Builder requires a Heroku API key. Directions for generating a key are here: [Heroku API Key](https://devcenter.heroku.com/articles/platform-api-quickstart)

The gem will look for the key in the HEROKU_API_KEY environment variable.  The key can be set either in your environment variable library (ex. dotenv):

```
# .env.local
HEROKU_API_KEY=xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxxx
```

or in front of the rake task:

```
HEROKU_API_KEY=xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxxx rake builder:staging:apply
```



### Running Rake Tasks

Heroku Builder currently has two actions: `apply` and `deploy`.  Apply will:

* Create the application, if it has not been created
* Set Config-vars (if there are changes)
* Deploy code (if there are changes)
* Configure Add-ons (if there are changes)
* Configure Resources (if there are changes)

As `apply` only adds or updates when your `heroku.yml` file has changes, it's safe to always use `apply` to deploy code.  Alternatively, you can just run the `deploy` portion.  Deploy will:

* Switch to the branch for that environment
* Pull down any remote changes
* Create a remote for Heroku, if the remote is not present
* Push to that remote

The environments defined in your `heroku.yml` file provide scope for the Heroku Builder rake tasks.  If you have the following:

```yaml
foo:
  ...
bar:
  ...
```

The four rake options would be:

    $ rake builder:foo:apply
    $ rake builder:foo:deploy
    $ rake builder:bar:apply
    $ rake builder:bar:deploy


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/heroku_builder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

