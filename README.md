# Dreamt In

Haiku tweeter and dream mapper. 24-hour hackathon project enabling users to anonymously map their dreams and tweet us places and get dream haikus about those places in return. Haikus are generated using words popular in the users' feed. Built using Ruby 2.1.4, Rails 4.2.0 and PostgreSQL.

## To run Locally

```
$ git clone <repo>
$ cd %s
$ bundle
```
For the web app:
```
$ rake db:create
$ rake db:migrate
$ rake db:seed
$ rails s
```
For the Twitter bot:
```
rake twitter:get_tweets
rake twitter:respond_to_tweets
```
