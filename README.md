# README

This is a very simple API for setup a new Bowling game, and manage its scores.

You can see a live version here: https://free-bowling.herokuapp.com

It is quite simple, it does not manage teams just yet, but it displays the status of the game (total, frames).

There is a small documentation in https://free-bowling.herokuapp.com/apidoc/index.html, to explain a bit about the endpoints.

# REQUIREMENTS

- Ruby 2.6.2
- PostgreSQL ~9.6

# INSTALLATION

Please make sure your config in the `config/database.yml` is the correct one.

```
bundle
bundle exec rails db:setup
bundle exec rails s
# In another terminal, just if you want to try the front-end part
yarn
./bin/webpack-dev-server
```

Once the services are up and running, you can go to `http://localhost:3000`
and create a new Game, which will give you the ID (uuid), which you will
need in order to send POST request for creating Scores (see the API documentation).

The state of the front-end is updated every 2 seconds, so you just need to send Scores
and wait until they appear in the screen. Of course you do not need the front-end at all,
you can make all the calls just using the API.

Running the tests (Minitest, of course! :)

```
bundle exec rails test
```
