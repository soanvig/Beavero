require 'test/unit'
require 'beavero.rb'

Dir.chdir( 'tests/test_enviroment' )

# Run build
$beavero = Beavero.new
$beavero.build

# Test build
class TestBeavero < Test::Unit::TestCase
    def test_paths
      assert_equal( $beavero.paths[:output], './public/' )
      assert_equal( $beavero.paths[:static], './static/' )
      assert_equal( $beavero.paths[:vendor], './vendor/' )
    end

    def test_create_output
      assert_equal( Dir.exist?( 'public' ), true )
    end

    # For compile_vendor and compile_static tests we scan vendor/static directory and public directory,
    # and substract the array of paths.
    # If result array is empty it means, that all vendor/static files are present in public directory
    # Dirs are being changed to make paths independent (without /vendor/ or /public/ at beginning)

    def test_compile_vendor
      Dir.chdir('vendor')
      vendor_files = Dir.glob('./**/*')

      Dir.chdir('../public')
      public_files = Dir.glob('./**/*')

      assert_equal( vendor_files - public_files, [] )

      Dir.chdir('..')
    end

    def test_compile_static
      Dir.chdir('static')
      static_files = Dir.glob('./**/*')

      Dir.chdir('../public')
      public_files = Dir.glob('./**/*')

      assert_equal( static_files - public_files, [] )

      Dir.chdir('..')
    end
end
