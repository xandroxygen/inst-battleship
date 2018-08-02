# --- Simple Tracker ---
# Moves linearly like the Dumb targeter, 
# but zeroes in on a ship once a hit has been made.

def getSquare(board, location)
  board[location[0]][location[1]]
end

def setSquare(board, location, value)
  board[location[0]][location[1]] = value
end

def getPosition(row, col)
  (col + 65).chr + row.to_s
end

def getNeighbors(row, col)
  ret = []
  ret << [row, col-1] if col > 1
  ret << [row-1, col] if row > 1
  ret << [row, col+1] if col < 9
  ret << [row+1, col] if row < 9
  ret
end

# returns null if fully explored
# else returns next square to target as [row,col]
def track_hit(board, row, col)
  queue = [[row,col]]
  while current = queue.shift
    puts queue.length
    # mark explored
    setSquare(board, current, "E")

    # if any neighbors are dashes, return first dash
    neighbors = getNeighbors(*current)
    neighbors.each do |n|
      return n if getSquare(board, n) == "-"
    end

    # if any neighbors are hits, explore them
    neighbors.each do |n|
      queue << n if getSquare(board, n) == "X"
    end
  end
end

def get_move(game)
  board = game['board']


  (0..9).each do |row|
    (0..9).each do |col|
      if (board[row][col] == "X")
        puts "tracking hit at #{row},#{col}"
        next_target = track_hit(board, row, col)
        puts next_target
        return getPosition(*next_target) if (next_target)
      end
    end
  end

  (0..9).each do |row|
    (0..9).each do |col|
      if (board[row][col] == "-")
        return getPosition(row, col)
      end
    end
  end
end