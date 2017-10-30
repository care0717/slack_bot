#!/bin/bash

ssh pi "cd /home/asai/dev/slack_bot && git pull origin master" 
ssh -t pi "sudo reboot"
echo "reboot start. wait 20sec"
sleep 20s

ssh pi "source ~/.profile && cd /home/asai/dev/slack_bot && bundle exec ruby main.rb &" 
echo "program start"
