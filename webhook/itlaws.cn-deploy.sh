#!/bin/bash

cd /var/www/itlaws.cn && git pull --recurse-submodules && rm -rf public && hugo