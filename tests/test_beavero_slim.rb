require 'test/unit'
require 'beavero.rb'

class TestBeaveroSlim < Test::Unit::TestCase
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
    html = File.read('public/index.html')
    assert_equal("<title>Super star</title><div class=\"content\"><ul><li>I am so awesome content</li><li>Really</li></ul></div>The rest of page<partial>I'm parsed partial</partial>And I'm unparsed partial!", html)
  end

  def test_search_layouts
    layouts = BeaveroSlim.send('search_layouts')

    assert_equal(
      {"main"=>"/home/mortimer/Ruby/My Gems/Beavero/tests/test_enviroment/./assets/slim/layouts/main.slim"},
      layouts
    )
  end

  def test_search_files
    files = BeaveroSlim.send('search_files')

    assert_equal(
      ['/home/mortimer/Ruby/My Gems/Beavero/tests/test_enviroment/./assets/slim/index.slim'],
      files
    )
  end
end
