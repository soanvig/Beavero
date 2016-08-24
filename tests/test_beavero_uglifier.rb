require 'test/unit'
require 'beavero.rb'

class TestBeaveroUglifier < Test::Unit::TestCase
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

  end

  def test_search_files
    files = BeaveroUglifier.send('search_files')
    wd = Beavero.config[:paths][:app]
    expected_files = [
      wd + "/./assets/js/app.js",
      wd + "/./assets/js/scripts.js",
      wd + "/./assets/js/folder/folderscript.js"
    ]

    assert_equal(files, expected_files)
  end
end
