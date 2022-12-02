#! /bin/sh
set -e

ANNOTATE_SKIP=true bundle exec rails db:migrate
RAILS_MAX_THREADS=20 bundle exec rake pub_sub_model_sync:start
