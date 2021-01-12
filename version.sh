#!/bin/bash
cat .env |  ./node_modules/.bin/semantic-release --no-ci
