class Beavero
  def self.build
    load_configuration
    load_modules
    create_output
    build_modules
  end

  private

  def self.load_configuration
    require 'json'
    config_path = './beavero_config.json'

    if( File.exists(config_path) )
      @@config = JSON.parse( File.read('./beavero_config.json'), symbolize_names: true )
      @@config[:paths][:app] = Dir.pwd

      @@modules = []
    else
      # The config file doesn't exist. Cannot proceed
      abort
    end
  end

  def self.load_modules
    @@modules = []

    @@config[:modules].each do |mod|
      # Join modules' names into paths beavero/module_name and require
      require_relative File.join( 'beavero', mod + '.rb' )

      # Convert module name to constant objects (required to include module)
      @@modules << Object.const_get('Beavero' + mod.capitalize)
    end

    # Include modules (unnecessary)
    # class_eval do
    #   @@modules.each do |mod|
    #     extend mod
    #   end
    # end
  end

  # Remove old output and create new one
  def self.create_output
    FileUtils.rm_rf @@config[:paths][:output]
    FileUtils.mkdir_p @@config[:paths][:output]
  end

  def self.build_modules
    @@modules.each do |mod|
      if(mod.respond_to? 'build')
        mod.send('build', @@config)
      else
        # WARNING: Module doesn't respond to build, ignoring
      end
    end
  end
end
