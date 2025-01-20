# moldule for saving and loading files
module Save_load_system
  def save
    JSON.dump({ board: @board, turn: @turn })
  end

  def self.load(save)
    data = JSON.load save
    new(data['board'], data['turn'])
  end

  def write_to_save_file
    save_data = save
    out_file = File.new('lib/save_files/save_file.json', 'w')
    out_file.puts(save_data)
    out_file.close
  end

  def create_save_file
    Dir.mkdir('lib/save_files') unless File.exist?('lib/save_files')
  end
end
