#!/bin/bash
set -e

ruby /rabbitmq_setup.rb

rabbitmqctl stop

exec rabbitmq-server
