# README
Sample Slots reservations app

## Main app dependencies
- Backend
    - Postgres
    - Ruby 3.1+
    - Rails 7+
    - Redis: Memory DB required for Turbo stream and action cable
    - Rubocop: Code style for frontend files
- Frontend
    - Bootstrap: UI Template
    - Typescript: Alternative to JS with static type checker (recommended to use jest library to test JS components)
    - Eslint: Code style for frontend files 

## Start the application
- development    
  Start the application: `docker-compose up app`    
  Visit the application: `http://localhost:3000`   
- test: `docker-compose run test` (runs all backend app tests)

## Misc
The application includes CI configuration ready to be executed once pushed to github