require 'test/unit'
require 'beavero.rb'

class TestBeaveroUglifier < Test::Unit::TestCase
  def setup
    # Switch to test enviroment
    Dir.chdir('tests/test_enviroment')

    # Clean test enviroment
    FileUtils.rm_rf( Dir.glob( './**/*' ) )

    # Create test enviroment
    FileUtils.copy_entry('../test_enviroment_configuration', '.')

    # Run build
    Beavero.build
  end

  def teardown
    Dir.chdir('../..')
  end

  def test_build
    require 'uglifier'

    puts "Test: Uglifier module/build"

    assets_files = Dir.glob('assets/js/**/*')
                   .reject { |val| File.directory? val }

    joined_files = assets_files.map { |file| File.read(file) }.join(' ')
    uglified_files = Uglifier.compile(joined_files)
    result_file = File.read('public/app.min.js')

    assert_equal( uglified_files, result_file )
  end
end
