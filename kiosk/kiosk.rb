#!ruby

require './bundle/bundler/setup'

require 'json'
require 'sinatra'

module Util
  extend self

  def utc_ts
    Time.now.utc
  end
end

class Point
  attr_reader :value, :created_at

  def initialize(value)
    @value = value
    @created_at = Util.utc_ts
  end

  def as_json
    {
      value: @value,
      created_at: @created_at.to_s,
    }
  end

  def self.inc
    new(1)
  end

  def self.dec
    new(-1)
  end
end

class Player
  def initialize(color, name=nil)
    @color = color
    @name = name || "#{color} player"
    @points = []
  end

  def inc
    @points << Point.inc
  end

  def dec
    @points << Point.dec
  end

  def score
    @points.reduce(0) do |m,v|
      m + v.value
    end
  end

  def as_json
    {
      color: @color,
      name: @name,
      points: @points.map(&:as_json),
    }
  end
end

class ScoreboardGame
  def initialize(blue=Player.new('blue'),red=Player.new('red'))
    @created_at = @updated_at = Util.utc_ts
    @players = {
      blue: blue,
      red: red,
    }
  end

  def update!
    @updated_at = Util.utc_ts
  end

  def player_action(color, action)
    update!
    @players[color.to_sym].send(action.to_sym)
  end

  def to_json
    JSON.dump(
      {
        'created_at' => @created_at.to_s,
        'updated_at' => @updated_at.to_s,
        'players' => @players.map do |k,v|
          {k => v.as_json}
        end.reduce(&:merge)
      }
    )
  end
end

$game = nil

def new_game
  $game = ScoreboardGame.new
end

def game
  $game ||= new_game
end

def render_game(code)
  content_type :json
  status code
  game.to_json
end


set :public_folder, 'public'

get '/scoreboard_game.json' do
  render_game 200
end

post '/scoreboard_game.json' do
  new_game
  render_game 201
end

put '/scoreboard_game/:color/:point_action.json' do
  game.player_action(params[:color], params[:point_action])
  render_game 200
end

get '/' do
  redirect '/index.html'
end
