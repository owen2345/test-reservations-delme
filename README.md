# README
Boilerplate Rails application intended to be used as a template for future Rails applications

## Main app dependencies
- Backend
    - Postgres
    - Ruby 3.1+
    - Rails 7+
    - Redis: Memory DB required for Turbo stream and Background jobs
    - Rubocop: Code style for frontend files
    - Pubsub (data sync between rails applications)
- Frontend
    - Bootstrap: UI Template
    - Typescript: Alternative to JS with static type checker (recommended to use jest library to test JS components instead of using capybara)
    - jsx-no-react: Treat html code as objects instead of plain string (recommended to use React instead because of the huge market of open source libraries)
    - Eslint: Code style for frontend files 

## Start the application
- `docker-compose build`
- `docker-compose up app`

## Run tests
- `docker-compose up test`

## Code style
- Backend
  ```bash
  rubocop
  ```
  
- Frontend
  ```bash
    yarn run eslint --ext .js,.jsx,.ts,.tsx app/frontend/
  ```

## Functionalities out of the box
- Authentication via auth0
- Pubsub configuration
- Code style configuration (backend and frontend)
- Tests configuration (backend and frontend)
- CI/CD configurations

