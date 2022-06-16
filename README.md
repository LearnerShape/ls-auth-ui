# ls-auth-ui #

## Run with docker-compose (for local development) ##

* git clone the repo
* set the required environment variables:

```ruby
# for communicating with ls-auth-api
LS_AUTH_API_KEY
LS_AUTH_API_URI
LS_AUTH_AUTH_TOKEN

# for sending emails
LS_MAILER_ADDRESS
LS_MAILER_PORT
LS_MAILER_USERNAME
LS_MAILER_PASSWORD
LS_MAILER_SENDER_EMAIL

# inside email templates
LS_TEMPLATE_NAME
LS_TEMPLATE_URI
```

* `docker-compose build`
* `docker-compose up`
* `docker-compose run web rake db:create db:migrate`

The ls-auth-ui app should then be accessible at localhost:3000.

## Use instructions ##

Now documented at [LearnerShape SkillsGraph](https://learnershape.gitbook.io/learnershape-skillsgraph/).
