require 'test/unit'
require 'beavero.rb'

class TestBeaveroImages < Test::Unit::TestCase
  def setup
    # Switch to test enviroment
    Dir.chdir('tests/test_enviroment')

    # Clean test enviroment
    FileUtils.rm_rf( Dir.glob( './*' ) )

    # Create test enviroment
    FileUtils.copy_entry('../test_enviroment_configuration', '.')

    # Run build
    Beavero.build
  end

  def teardown
    Dir.chdir('../..')
  end

  def test_build
    puts "Test: Images module/build"

    assets_files = Dir.glob('assets/images/**/*')
                   .reject { |val| File.directory? val }
    public_files = Dir.glob('public/**/*')
                   .reject { |val| File.directory? val }
                   .map { |val| File.basename(val) }

    # Add thumbnail files to assets_files
    # .clone because of endless loop
    assets_files.clone.each do |file|
      # but only if the file is in thumbs directory 
      # (.dirname is file's parent directory, and .basename is its name )
      if File.basename( File.dirname(file) ) == 'thumbs'
        ext = File.extname(file)
        name = File.basename(file, ext)
        assets_files << name + '.thumb' + ext
      end
    end

    assets_files.map! { |val| File.basename(val) }

    count = 0

    assets_files.each do |file|
      count += 1 if public_files.include? file
    end

    assert_equal( assets_files.count, count )
  end
end
