
$moves = ('A'..'J').map do |l|
  (0..9).map do |n|
    l + n.to_s
  end
end.flatten

def get_move(board)
  $moves.shift
end