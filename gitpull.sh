#!/bin/bash

read -p "Do you really want to pull the lastest version? " c
git reset --hard HEAD
git clean -f -d
git pull
