#! /bin/sh

# run server as production
RAILS_SERVE_STATIC_FILES=true bin/rails s -e production -p 3000 > '/dev/null' &
