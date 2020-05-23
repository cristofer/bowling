# README

This is a very simple API for setup a new Bowling game, and manage its scores. (please refer to https://en.wikipedia.org/wiki/Ten-pin_bowling#Scoring for the rules of the Ten Pin Bowling).

It is quite simple, it does not manage teams just yet, but it displays the status of the game (total, frames).

There is a small documentation in http://localhost:3000/apidoc/index.html, to explain a bit about the endpoints.

The total on each Frame is just that total, not the Total of the Game, the client should handle that logic accordingly (for the live demo the Total of the game is displayed on top).

# REQUIREMENTS

- Ruby 2.7.1
- PostgreSQL >= 9.6

# INSTALLATION

Please make sure your config in the `config/database.yml` is the correct one.

And also change the corresponding URLs https://github.com/cristofer/bowling/blob/master/app/javascript/constants/index.js

```
bundle
bundle exec rails db:setup
bundle exec rails s
```

Once the services are up and running, you can go to `http://localhost:3000`
and create a new Game, which will give you the ID (uuid), which you will
need in order to send POST request for creating Scores (see the API documentation).

The state in the front end is updated using Websockets.

Running the tests (Minitest, of course! :)

```
bundle exec rails test
```

# ActionCable

So I implemented a very simple Channel (`GamesChannel`) using `ActionCable`, before I was using a 2 seconds
interval in order to retrieve the status of the game, now the states in the Front-End is updated only
when the a new score is annotated for the specific game.
