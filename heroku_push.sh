#!/bin/sh
git push heroku `git subtree split --prefix check-my-library master`:master --force
