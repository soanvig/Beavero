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
    puts "Test: Vendor module/build"

    assets_files = Dir.glob('vendor/**/*')
                   .reject { |val| File.directory? val }
                   .map { |val| File.basename(val) }
    public_files = Dir.glob('public/**/*')
                   .reject { |val| File.directory? val }
                   .map { |val| File.basename(val) }

    count = 0

    assets_files.each do |file|
      count += 1 if public_files.include? file
    end

    assert_equal( assets_files.count, count )
  end
end
