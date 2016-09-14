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
    Dir.chdir('assets/images')
    images_files = Dir.glob('./**/*').reject do |path|
      File.directory? path
    end
    images_files.map! { |image| File.basename(image) }

    Dir.chdir('../../public')
    public_files = Dir.glob('./**/*')
    public_files.map! { |file| File.basename(file) }

    puts public_files

    assert_equal( [], images_files - public_files )

    Dir.chdir('..')
  end
end
