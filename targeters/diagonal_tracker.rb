# --- Diagonal Tracker ---
# like the Simple Tracker, but only checks
# a "checkerboard" of squares

def track_hit(board, cell)
  queue = [cell]
  while current = queue.shift
    # mark explored
    board.explore!(current)
    
    # if any neighbors are dashes, return first dash
    blank = board.next_blank_neighbor(current)
    return blank if blank != nil

    # if any neighbors are hits, explore them
    queue += board.hit_neighbors(cell)
  end
end

def get_move(board)
  board.each_hit do |cell|
    next_target = track_hit(board, cell)
    return Board.cell_as_string(next_target) if (next_target)
  end

  board.each_diagonal_blank do |cell|
    return Board.cell_as_string(cell)
  end

  board.each_diagonal_blank(true) do |cell|
    return Board.cell_as_string(cell)
  end
end