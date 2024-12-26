require_relative 'chesspiece_main'

# Check if pawn made legal moves change pawn to queen when at end of board
class Pawn < Chesspiece
  include Basic_tools
  attr_accessor :has_move

  def initialize(type, color)
    @type = type
    @color = color
    @has_move = false
  end

  def pawn_move_check(chesspiece_location, chesspiece_distination, board)
    possible_moves = generate_moves(chesspiece_location)

    return false if get_chesspiece_from_board(possible_moves.flatten(1).last, board).is_a?(Chesspiece)

    pawn_reach_end_of_board?(chesspiece_location, chesspiece_distination, board)

    possible_moves = opponent_chesspiece_nearby_own_piece(possible_moves, chesspiece_location, board)

    if possible_moves.flatten(1).include?(chesspiece_distination)
      @has_move = true
      return true
    end

    false
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    if @color == 'white'
      generate_one_or_two_up_moves(possible_moves, ver_pos, hor_pos)
    elsif @color == 'black'
      generate_one_or_two_down_moves(possible_moves, ver_pos, hor_pos)
    end

    [possible_moves]
  end

  def generate_one_or_two_up_moves(possible_moves, ver_pos, hor_pos)
    if @has_move == true
      possible_moves << [ver_pos + 1, hor_pos]
    else
      possible_moves << [ver_pos + 1, hor_pos]
      possible_moves << [ver_pos + 2, hor_pos]
    end
  end

  def generate_one_or_two_down_moves(possible_moves, ver_pos, hor_pos)
    if @has_move == true
      possible_moves << [ver_pos - 1, hor_pos]
    else
      possible_moves << [ver_pos - 1, hor_pos]
      possible_moves << [ver_pos - 2, hor_pos]
    end
  end

  def opponent_chesspiece_nearby_own_piece(possible_moves, chesspiece_location, board)
    ver_pos = chesspiece_location[0]
    hor_pos = chesspiece_location[1]

    both_side = []

    current_pawn = get_chesspiece_from_board(chesspiece_location, board)

    if current_pawn.color == 'white'
      possible_moves = attack_black_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    elsif current_pawn.color == 'black'
      possible_moves = attack_white_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    end

    [possible_moves.flatten(1)]
  end

  def attack_black_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    both_side << [ver_pos + 1, hor_pos + 1] # right side
    both_side << [ver_pos + 1, hor_pos - 1] # left side

    both_side.select! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) && get_chesspiece_from_board(move, board).color == 'black' } # rubocop:disable Layout/LineLength

    possible_moves << both_side
  end

  def attack_white_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    both_side << [ver_pos - 1, hor_pos + 1] # right side
    both_side << [ver_pos - 1, hor_pos - 1] # left side

    both_side.select! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) && get_chesspiece_from_board(move, board).color == 'white' } # rubocop:disable Layout/LineLength

    possible_moves << both_side
  end

  def pawn_reach_end_of_board?(chesspiece_location, chesspiece_distination, board)
    if chesspiece_distination[0] >= 8 && @color == 'white'
      add_new_chesspiece(chesspiece_location, '♛', @color, board)
      p 'white Pawn is now queen'
    elsif chesspiece_distination[0] <= 1 && @color == 'black'
      add_new_chesspiece(chesspiece_location, '♕', @color, board)
      p 'black Pawn is now queen'
    end
  end
end
