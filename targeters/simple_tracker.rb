# --- Simple Tracker ---
# Moves linearly like the Dumb targeter, 
# but zeroes in on a ship once a hit has been made.

$moves = ('A'..'J').map do |l|
  (0..9).map do |n|
    l + n.to_s
  end
end.flatten

def getSquare(position)
  l = position[0]
  n = position[1]
  (l.ord - 65, n)
end

def getPosition(row, col)
  (row + 65).chr + col.to_s
end

# returns null if fully explored
# else returns next square to target as [row,col]
def track_hit(row, col)
  return nil
end

def get_moves(game)
  board = game['board']

  possibilities = []

  (0..9).each do |row|
    (0..9).each do |col|
      if (board[row][col] == "X")
        next_target = track_hit(row, col)
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