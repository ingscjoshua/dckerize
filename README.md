# Dckerize

Supercharged Rails development using Docker and Vagrant

## Description

This gem gives you a good starting point for developing your Rails application using containers managed by Docker
inside of a VM managed by Vagrant.

You'll get

- An ubuntu trusty image already provisioned with Docker and Docker Compose.
- An nginx/passenger container environment for serving your application and all the necessary configurations.
- A separate container running MySQL/postgres for your DB.
- A separate container for keeping your data using the data-only container pattern.

## Requirements

- Ruby and Bundler
- Vagrant >= 1.6

## Installation

    $ gem install dckerize

## Usage

You need to have a Rails application already created.

In the root of your application run:

    $ dckerize up APP_NAME --database=[mysql|postgres]

Where APP_NAME should be the same name of your application and you must specify the database
that you want to use.

### Generated Structure

Dckerize will generate:

- A Vagrant folder, which contains a Vagrantfile and a docker-compose-installer bash script for provisioning.
- A conf folder containing an nginx configuration file for your site and an environment definition file for passing
the necessary environment variables to passenger. Any extra environment variables passed to your Rails application
should be declared in this file.
- A Dockerfile for building your application.
- A docker-compose.yml file for starting your entire enviroment inside the VM.

### DB configuration

## MySQL
In your config/database.yml add these lines to your configuration:

    username: root
    password: <%= ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'] %>
    host: mysql

## Postgres
In your config/database.yml add these lines to your configuration:

    user: postgres
    password: <%= ENV['POSTGRES_ENV_POSTGRES_PASSWORD'] %> 
    host: postgres

### Developing

Go inside the generated vagrant folder and run

    $ vagrant up

Vagrant will pull the ubuntu trusty image, the necessary docker images and set the shared folder for
development.

Once finished, run

    $ vagrant ssh
    $ cd /APP_NAME
    $ docker-compose up -d

Since the folder is being shared with the virtual machine, you can run docker-compose using the docker-compose.yml file.
This will build the container for your application, the db and the links between the containers.

The application folder will also be mounted inside the container, so you can work as you normally do locally and see the changes
reflected immediately inside the container.

Now you can go inside the container and run the typical Rails commands for interacting with your application.

To get the app container's name run:

    $ docker ps

This will show you all the running containers. Choose the one that's running your app and go inside by executing:

    $ docker exec -it CONTAINER_NAME bash

Now you can interact with your application

    $ rake db:create
    $ rake db:migrate
    $ rails c

And etc.

The nginx container is mapping its port 80 with the port 80 of the guest host, and since we're declaring a private network in our Vagranfile
you can access your application by visiting http://192.168.50.4.

## Contributing

1. Fork it ( https://github.com/pacuna/dckerize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
