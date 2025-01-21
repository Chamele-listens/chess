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
end
