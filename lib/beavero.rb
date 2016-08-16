class Beavero
  attr_accessor :paths

  def initialize

  end

  def build
    define_paths
    create_output
    compile_vendor
    compile_static
  end

  private

  def define_paths
    @paths = {} unless @paths

    @paths[:output] = './public/'
    @paths[:static] = './static/'
    @paths[:vendor] = './vendor/'
  end

  # Remove old output and create new one
  def create_output
    FileUtils.rm_rf @paths[:output]
    FileUtils.mkdir_p @paths[:output]
  end

  # Compile vendor directory
  def compile_vendor
    # Full copy
    FileUtils.copy_entry( @paths[:vendor], @paths[:output] )
  end

  # Compile static directory
  def compile_static
    # Full copy
    FileUtils.copy_entry( @paths[:static], @paths[:output] )
  end

end
