def get_setup 
{
  carrier: { position: "A0", direction: "DOWN"},
  battleship: { position: "B0", direction: "DOWN"},
  cruiser: { position: "C0", direction: "DOWN"},
  destroyer: { position: "D0", direction: "DOWN"},
  submarine: { position: "E0", direction: "DOWN"},
}
end

$moves = ('A'..'J').map do |l|
  (0..9).map do |n|
    l + n.to_s
  end
end.flatten

def get_move(board)
  $moves.shift
end