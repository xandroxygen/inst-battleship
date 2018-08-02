#require_relative "../lib/board"

$lengths = { carrier: 5, battleship: 4, cruiser: 3, destroyer: 2, submarine: 1}
$directions = [:UP, :RIGHT, :LEFT, :DOWN]

def get_setup 
  quadrants = [
    [0..4, 0..4],
    [0..4, 5..9],
    [5..9, 0..4],
    [5..9, 5..9],
    [2..7, 2..7]
  ]
  ships = [:carrier, :battleship, :cruiser, :destroyer, :submarine].shuffle
  placements = {}
  taken = []

  quadrants.zip(ships).each do |quadrant, ship| 
    loop do 
      x = quadrant[0].to_a.shuffle.first
      y = quadrant[1].to_a.shuffle.first
      d = $directions.shuffle.first

      # turn into list of cells
      delta = $lengths[ship]-1
      cells, x, y, d = case d
      when :UP
        [(-delta..0).map { |row| [row + x,y]}, x-delta, y, "DOWN"]
      when :DOWN
        [(0..delta).map { |row| [row + x,y]}, x, y,"DOWN"]
      when :LEFT
        [(-delta..0).map { |col| [x,col + y]}, x, y-delta, "LEFT"]
      when :RIGHT
        [(0..delta).map { |col| [x,col + y]}, x, y, "LEFT"]
      end

      # any cells off the edge?
      next if cells.flatten.any? { |c| c < 0 || c > 9 }
      # any cells in taken
      next unless (taken & cells).empty?

      # add data to placement
      
      placements[ship] = { position: Board.cell_as_string([x,y]), direction: d}
      taken += cells
      break
    end
  end
  placements
end