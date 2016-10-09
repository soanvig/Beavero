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
    puts "Test: Slim module/build"

    html = File.read('public/index.html')
    assert_equal("<title>Super star</title><div class=\"content\"><ul><li>I am so awesome content</li><li>Really</li></ul></div>The rest of page<partial>I'm parsed partial</partial>And I'm unparsed partial!", html)
  end

  def test_search_layouts
    puts "Test: Slim module/search_layouts"

    layouts = BeaveroSlim.send('search_layouts')
    path = File.join(Beavero.config[:paths][:app], './assets/slim/layouts/main.slim')


    assert_equal(
      {"main"=>path},
      layouts
    )
  end

  def test_search_files
    puts "Test: Slim module/search_files"

    files = BeaveroSlim.send('search_files')
    path = File.join(Beavero.config[:paths][:app], './assets/slim/index.slim')

    assert_equal(
      [path],
      files
    )
  end
end
