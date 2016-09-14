require 'test/unit'
require 'beavero.rb'

class TestBeaveroVendor < Test::Unit::TestCase
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
    Dir.chdir('vendor')
    vendor_files = Dir.glob('./**/*')

    Dir.chdir('../public')
    public_files = Dir.glob('./**/*')

    assert_equal( [], vendor_files - public_files )

    Dir.chdir('..')
  end
end
