#!/usr/bin/env ruby

require "json"
require "net/http"
require "optparse"
require "./brain.rb"

def create_game(client)
  req = Net::HTTP::Post.new("/games", "Content-Type" => "application/json")
  res = client.request(req)

  JSON.parse(res.body)["id"]
end

def join_game(client, player_name, ships, game_id, auto)
  url = "/games/#{game_id}/players"
  if auto
    url += "?match=1"
  end
  req = Net::HTTP::Post.new(url,
                            "Content-Type" => "application/json")
  body = { name: player_name }.merge(ships)
  req.body = body.to_json

  puts body
  JSON.parse(client.request(req).body)
end

def play(client, game_id, secret, position)
  req = Net::HTTP::Post.new("/games/#{game_id}/moves",
                            "Content-Type" => "application/json",
                            "X-Token" => secret)
  req.body = { position: position }.to_json

  JSON.parse(client.request(req).body)
end

def print_board(game)
  # printed_boards = game["boards"].map do |board|
  #   board["rows"].map do |row|
  #     row.map { |cell| cell || "-" }.join(" ")
  #   end
  # end

  # [0, 3, 6].each do |i|
  #   (0..2).each do |j|
  #     puts [printed_boards[i][j],
  #           printed_boards[i+1][j],
  #           printed_boards[i+2][j]].join("  ")
  #   end
  #   puts "\n"
  # end
  # puts "* * *\n\n"
  p game
end

http_client = Net::HTTP.new("battleship.inseng.net", 80)
options = {}

OptionParser.new do |opts|
  opts.on("-p", "--player=PLAYER", "Player name") do |v|
    options[:player_name] = v
  end

  opts.on("-g", "--game=GAME", "Game id") do |v|
    options[:game] = v
  end

  opts.on("-a", "--auto", "if set, pair with a robot player") do |v|
    options[:auto] = v
  end
end.parse!

player_name = options[:player_name]
game_id     = options[:game] ? options[:game] : create_game(http_client)
puts game_id

ships = get_setup()
game = join_game(http_client, player_name, ships, game_id, options[:auto])
loop do
  print_board(game)
  break if game["winner"] != nil

  position = get_move(game)
  puts "New move: #{position}\n\n\n"

  game = play(http_client, game["id"], game["currentPlayer"]["token"], position)
end

puts "Game winner: #{game["winner"]}"
puts "Game winReason: #{game["winReason"]}"