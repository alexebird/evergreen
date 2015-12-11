#!/bin/bash

source /root/evergreen-env.sh
PI_IP='192.168.19.8'
GAME_FILE='/tmp/game.json'

#curl_web_app()
#{
  #curl -k -XPUT -H\"Authorization: ${GRPINGPONG_API_KEY}\" ${MOTHERSHIP}/api/ -d@${GAME_FILE}
#}

curl_pi_point_action()
{
  local color=$1
  local point_action=$2

  curl -XPUT -H'Content-Length: 0' ${PI_IP}/scoreboard_game/${color}/${point_action}.json > ${GAME_FILE}
}

red_inc_point()
{
  curl_pi_point_action red inc
}

red_dec_point()
{
  curl_pi_point_action red dec
}

blue_inc_point()
{
  curl_pi_point_action blue inc
}

blue_dec_point()
{
  curl_pi_point_action blue dec
}

new_game()
{
  curl -XPOST -H'Content-Length: 0' ${PI_IP}/scoreboard_game.json > ${GAME_FILE}
}
