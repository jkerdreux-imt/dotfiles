#!/bin/bash

cat ~/.ssh/known_hosts|grep .home|grep -v "]"|cut -d" " -f 1|sort|uniq

