# moldule for saving and loading files
module Save_load_system
  def save
    JSON.dump({ board: @board, turn: @turn })
  end

  def self.load(save)
    data = JSON.load save
    new(data['board'], data['turn'])
  end

  def create_save_file
    Dir.mkdir('./save_files') unless File.exist?('./save_files')
  end
end
