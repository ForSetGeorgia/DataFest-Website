# - copy all folders/files into build folder
# - for each img, css, and js file
#   - generate a digest of the file and add to file name
#   - update all html files with correct filename


require 'digest/md5'
require 'fileutils'

build_path = 'build/'
html_files = ['index.html', 'partners.html', 'speakers.html', 'agenda-day1.html', 'agenda-day2.html', 'agenda-day3.html']
asset_folders = ['css', 'img', 'js']
items_to_build = html_files + asset_folders
files_to_digest = ['css', 'js', 'png', 'jpg', 'svg', 'mp4']
files_to_update_with_file_digest = ['html', 'css']

# first delete what is in build folder
puts 'deleting items in build folder'
FileUtils.rm_rf(Dir.glob(build_path + '*'))

# copy all desired items into build folder
puts 'copying items to build folder'
items_to_build.each do |item|
  FileUtils.cp_r (item), (build_path + item)
end

# get list of files that need to be digested
to_digest = Dir.glob(build_path + '**/*.{' + files_to_digest.join(',') + '}')
puts "there are #{to_digest.length} files to add digest to"

# for each file,
# - generate digest
# - update filename
digested = []
to_digest.each do |file|
  puts '------------'
  # only digest if not a font (in case there are svg font files)
  if (file.index('/fonts/') != -1)
    # compute digest
    puts '- creating digest'
    original_file_name = file.split('/').last
    ext = File.extname(original_file_name)
    base_name = File.basename(original_file_name, ext)
    digest = Digest::MD5.hexdigest(File.read(file))
    new_file_name = base_name + '-' + digest + ext
    new_file = file.gsub(original_file_name, '') + new_file_name
    puts file
    puts new_file
    digested << {
      file: file,
      original_file_name: original_file_name,
      new_file: new_file,
      new_file_name: new_file_name
    }

    # update file name
    puts '- renaming file'
    FileUtils.mv file, new_file
  end
end

# get list of files that will need to be searched through to update the asset filename
to_update_with_file_digest = Dir.glob(build_path + '**/*.{' + files_to_update_with_file_digest.join(',') + '}')
puts "there are #{to_update_with_file_digest.length} files to to update asset file names in"

# go through all files and update asset filename
puts 'updating reference to file'
to_update_with_file_digest.each do |file_to_update|
  content = File.read(file_to_update)

  # reference to the asset might occur in different forms:
  # look for asset_folder/filename and then just filename
  digested.each do |digested_file|
    content = content.gsub(digested_file[:file].gsub(build_path, ''), digested_file[:new_file].gsub(build_path, ''))
  end
  digested.each do |digested_file|
    content = content.gsub(digested_file[:original_file_name], digested_file[:new_file_name])
  end

  File.open(file_to_update, 'w') {|f| f.write(content)}

end

