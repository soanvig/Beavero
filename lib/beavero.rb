require 'json'
require 'logger'

class Beavero
  def self.build
    load_configuration
    load_modules
    create_output
    build_modules
  end


  # Log message (https://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
  # @param message (string) - message to show
  # @param level (string) - ('unknown', 'fatal', 'error', 'warn', 'info', 'debug') default: 'info'
  def self.log( message, level = 'info' )
    load_logger unless defined? @@logger
    @@logger.send(level, message)
  end

  private

  def self.load_logger
    unless defined? @@logger
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::INFO
    end
  end

  def self.load_configuration
    config_path = './beavero_config.json'

    if( File.exist?(config_path) )
      @@config = JSON.parse( File.read('./beavero_config.json'), symbolize_names: true )
      @@config[:paths][:app] = Dir.pwd

      @@modules = []
    else
      log("Config file doesn't exist. Cannot proceed, quiting.", 'error')
      abort
    end
  end

  def self.load_modules
    @@modules = []

    @@config[:modules].each do |mod|
      # Join modules' names into paths beavero/module_name and require
      require File.join( 'beavero', mod + '.rb' )

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
        log("Module doesn't respond to 'build'. Ignoring.", 'warn')
      end
    end
  end
end
