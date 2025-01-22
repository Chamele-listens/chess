require 'oj'

# moldule for saving and loading files
module Save_load_system
  def write_to_save_file(game_object)
    save_data = Oj.dump(game_object)
    out_file = File.new('lib/save_files/save_file.json', 'w')
    out_file.puts(save_data)
    out_file.close
  end

  def load_from_save_file
    file_in = File.read('lib/save_files/save_file.json')
    Oj.load(file_in)
  end

  def create_save_files_folder
    Dir.mkdir('lib/save_files') unless File.exist?('lib/save_files')
  end

  def save_load?(player_input, game_object)
    return false if player_input.count('a-zA-Z') <= 0

    create_save_files_folder

    if player_input == 'save'
      return true if save_file_override? == false

      save(game_object)
    elsif player_input == 'load'
      load
    else
      p 'not vaild input'
    end

    true
  end

  def save(game_object)
    write_to_save_file(game_object)
    p 'Game has been saved'
  end

  def save_file_override?
    return unless File.exist?('lib/save_files/save_file.json')

    p 'Do you want to override your save file? (y/n)'
    input = gets.chomp.downcase

    return true if %w[y yes].include?(input)

    false
  end

  def load
    return p 'There is no save file' unless File.exist?('lib/save_files/save_file.json')

    save_data = load_from_save_file
    @board = save_data.board
    @turn = save_data.turn
    p 'Game has been loaded'
  end
end
