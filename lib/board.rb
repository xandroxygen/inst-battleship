class Board
  def initialize(board)
    @board = board
  end

  def [](location)
    @board[location[0]][location[1]]
  end

  def []=(location, value)
    @board[location[0]][location[1]] = value
  end

  def hit_at?(location)
    self[location] == "X"
  end

  def miss_at?(location)
    self[location] == "O"
  end

  def blank_at?(location)
    self[location] == "-"
  end

  def explore!(location)
    self[location] = "E"
  end

  def print
    puts "  " + ('A'..'J').to_a.join("")
    (0..9).each do |row|
      puts row.to_s + " " + @board[row].join("")
    end
  end

  def self.each_cell
    (0..9).each do |row|
      (0..9).each do |col|
        yield [row,col]
      end
    end
  end

  def self.each_spiral_cell
    yield [4,4]
    (4..5).each { |i| yield [i,5] }
    (3..4).each { |i| yield [5,i] }
    (3..4).each { |i| yield [i,3] }
    (4..6).each { |i| yield [3,i] }
    (4..6).each { |i| yield [i,6] }
    (2..5).each { |i| yield [6,i] }
    (2..5).each { |i| yield [i,2] }
    (3..7).each { |i| yield [2,i] }
    (3..7).each { |i| yield [i,7] }
    (1..6).each { |i| yield [7,i] }
    (1..6).each { |i| yield [i,1] }
    (2..8).each { |i| yield [1,i] }
    (2..8).each { |i| yield [i,8] }
    (0..7).each { |i| yield [8,i] }
    (0..7).each { |i| yield [i,0] }
    (1..9).each { |i| yield [0,i] }
    (1..9).each { |i| yield [i,9] }
    (0..8).each { |i| yield [9,i] }
  end

  def self.each_diagonal_cell(white)
    each_cell do |cell|
      yield cell if cell.sum % 2 == (white ? 0 : 1)
    end
  end

  def self.each_spiral_diagonal_cell(white)
    each_spiral_cell do |cell|
      yield cell if cell.sum % 2 == (white ? 0 : 1)
    end
  end

  def each_hit
    Board.each_cell do |cell|
      yield cell if hit_at? cell
    end
  end

  def each_blank
    Board.each_cell do |cell|
      yield cell if blank_at? cell
    end
  end

  def each_diagonal_blank(white = false)
    Board.each_diagonal_cell(white) do |cell|
      yield cell if blank_at? cell
    end
  end

  def each_spiral_diagonal_blank(white = false)
    Board.each_spiral_diagonal_cell(white) do |cell|
      yield cell if blank_at? cell
    end
  end

  def self.get_neighbors(cell)
    row, col = cell
    ret = []
    ret << [row, col-1] if col > 1
    ret << [row-1, col] if row > 1
    ret << [row, col+1] if col < 9
    ret << [row+1, col] if row < 9
    ret
  end

  def next_blank_neighbor(cell)
    Board.get_neighbors(cell).find { |n| self.blank_at?(n) } 
  end

  def hit_neighbors(cell)
    Board.get_neighbors(cell).select { |n| self.hit_at?(n) }
  end

  def self.cell_as_string(cell)
    row, col = cell
    (col + 65).chr + row.to_s
  end

end