# README  - ermahgerd-rails-api-cognito
         
The Rails API server for Canadian Pump & Packing Distribution.  Serves up JSONAPI payloads for an EmberJs SPA
over at [https://github.com/cybertooth-io/ccpdist-com-emberjs](https://github.com/cybertooth-io/ccpdist-com-emberjs).

## Development - Getting Started

You need the following:

* Ruby-2.3+ - suggest Ruby-2.5 but check your production environment to be sure -- e.g. AWS EB
* Docker - we use two containers, one for the PostgreSQL database and one for Redis
* The `config/master.key` file

### First Time Setting Up

Perform the following from the command line:

1. Create your config/credentials.yml.enc file (see _No Secrets Here - Credentials Instead_ section below).
1. `bundle install` - will install any of the missing gems declared in the `Gemfile`
1. `docker-compose up -d` - start up a Redis and PostgreSQL server in a container
1. `rake db:create` - only required the first time, make sure your database is created
1. `rake db:migrate` - run as required, your application will produce a stacktrace of errors if you're not up to date
1. `rake db:seed_fu` - run as required, to seed the database with data
1. `rake test` - run as required, test to make sure your API is behaving

### Running The Server

`rails s` - to serve the API on [http://localhost:3000](http://localhost:3000)

### Database Seeds

For development, feel free to edit the `db/fixtures/development/002_users.rb` file to add yourself.

Seed the database with:

```bash
$ rake db:seed_fu
```

### Redis

Redis is used by Sidekiq to queue up jobs.

Sidekiq is configured in `config/initializers/sidekiq.rb` to use database `1`.

### Crons/Jobs/Queues

If you're creating Sidekiq jobs please use the generator: `rails g sidekiq:worker record_session_activity`

### Development Workflow

1. Create a model with its **singular name**: `rails g model role key:string name:string notes:text`
    1. Edit the migration to ensure the `default` and `null` values are defined
    1. Add validations, relationships, scopes, etc. to the new model class
    1. Is the model audited?  Yes, then add the `audited` declaration to the model class
    1. Add test fixture data accordingly to `test/fixtures/*.yml` (keep it general and un-crazy)
    1. Unit test accordingly
    1. Add the model information to the `config/locales/*.yml` file(s)
1. Create the pundit policy with the **model's singular name**: `rails g pundit:policy role`
    1. Make sure your policy file extends `ApplicationPolicy` (it should by default)
    1. Override `create?`, `destroy?`, `index?`, `show?`, and `update?` accordingly
    1. Unit test accordingly
    1. Add the policy error messages to the `config/locales/*.yml` if so desired
1. Create the protected resource using the **model's singular name** at the appropriate api path: 
`rails g jsonapi:resource api/v1/protected/role`
    1. Make sure the resource extends `BaseResource`
    1. Add the appropriate attributes from the model that will be serialized in the JSONAPI payload
    1. Make sure all relationships you want exposed are added
    1. Add any filters that use model scopes
    1. Unit test accordingly through the controller (next step)
1. Create the protected controller using the **model's plural name** at the appropriate api path:
`rails g controller api/v1/protected/roles`
    1. Make sure the controller extends `BaseResourceController`
    1. Add the controller's end points to the `config/routes.rb` file; use `jsonapi_resources` helper :-)
    1. Unit test accordingly (e.g. confirm returned payload only contains the fields specified in the resource)

### Commiting Code

1. Use a branch and a pull request into master.
1. Run `rubocop -a` prior to commits to make sure your code conforms to the formatting and linting.

----

## Configuration Notes

The `config/initializers/ermahgerd.rb` can be used to override a number of configuration options.

The Configuration options are set to their defaults in `lib/ermahgerd/configuration.rb`; check out the
initialize method.

----

## No Secrets Here - Credentials Instead

As of Rails-5.2 secrets are hashed and locked down with the `config/master.key` file.  Run `rails credentials:help` for
more information.

This application ships with an already created `config/credentials.yml.enc` and we share the `master.key` amongst
ourselves ... but not with Joe Public (or Josephine Public)

If you're forking this or trying it yourself, you'll want to:

1. `rm config/credentials.yml.enc` to get rid of the current credentials
1. `rails credentials:edit`
1. Add the keys that are described in the section below; don't forget to use the `rake secret` to create your keys

### Keys in `config/credentials.yml.enc`

```bash
$ rails credentials:edit  # you might have to destroy the existing `config/credentials.yml.enc` if this command fails
```

`secret_key_base` - used by most Rails apps in one way or another (e.g. BCrypt).  Please set this to a
strong key; all environments (development, test, etc.) require this to be set.

`jwk_set` - the set of JWK from Cognito that will be used to decode supplied Authorization tokens.  Yours will be found
at `https://cognito-idp.{region}.amazonaws.com/{userPoolId}/.well-known/jwks.json`.  
Check out the Cognito docs: [https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-verifying-a-jwt.html#amazon-cognito-user-pools-using-tokens-step-2]
By default, the TEST environment of this app does not use this JWK set.  DEVELOPMENT & PRODUCTION do use this unless
you change the configuration through `config/initializers/ermahgerd.rb`.

`token_aud` - name of the audience in your token from Cognito; makes sure not just any Cognito token 
can access this app.  You can get this information from your Cognito configuration or the payloads 
from your authentication requests to Cognito.  By default, the TEST environment of this app does 
not use this setting; it makes up a fake audience value.  DEVELOPMENT & PRODUCTION do use this unless
you change the configuration through `config/initializers/ermahgerd.rb`.


`token_iss` - the url that issued the token.  You can get this information from your Cognito configuration 
or the payloads from your authentication requests to Cognito.  By default, the TEST environment of this app does 
not use this setting; it makes up a fake audience value.  DEVELOPMENT & PRODUCTION do use this unless
you change the configuration through `config/initializers/ermahgerd.rb`.

----

## Releasing

1. Confirm (and edit) the `config/application.rb`'s version property.
1. Commit.
1. Tag: `git tag v#.#.#`
1. Edit the `config/application.rb`'s version property.
1. Commit & push everything.

----

## Deployment

_Coming soon_

## Contributing

Team members, create a branch and pull request.

General Public: Fork and create pull request.

