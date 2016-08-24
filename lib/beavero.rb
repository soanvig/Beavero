require 'json'
require 'logger'
require 'colorize'
require 'fileutils'

class Beavero
  def self.build
    load_logger
    load_configuration
    load_modules
    create_output
    build_modules
  end

  # Log message (https://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
  # @param message (string) - message to show
  # @param level (string) - ('error', 'warn', 'info', 'debug', 'success') default: 'info'
  def self.log( message, type = 'info' )
    load_logger unless defined? @@logger
    load_configuration unless defined? @@config

    # Check for allowed log type
    if( @@config[:logger][:types].include? type )
      message = message.colorize(@@config[:colors][type.to_sym])

      # If used custom log type like 'success', convert it into 'info' type
      type = 'info' if @@config[:logger][:custom_types].include? type

      @@logger.send( type, message )
    else
      log( 'Mod tried to send illegal message type: ' + type, 'debug' )
    end
  end

  def self.config
    @@config
  end

  private

  def self.load_logger
    unless defined? @@logger
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::INFO
      @@logger.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
    end
  end

  def self.load_configuration
    config_path = './beavero_config.json'

    @@config = {}
    @@modules = []

    # Defaults
    @@config[:paths] = {}
    @@config[:paths][:app] = Dir.pwd
    @@config[:paths][:output] = './public/'

    @@config[:logger] = {}
    @@config[:logger][:types]   = ['error', 'warn', 'info', 'debug', 'success']
    # Custom types will be converted into 'info' type for logger
    @@config[:logger][:custom_types] = ['success']

    @@config[:colors] = {}
    @@config[:colors][:success] = { color: :green }
    @@config[:colors][:info]    = { color: :white }
    @@config[:colors][:error]   = { color: :white, background: :red }
    @@config[:colors][:debug]   = { color: :white }
    @@config[:colors][:warn]    = { color: :yellow }

    @@config[:modules] = ['static', 'vendor']

    if( File.exist?(config_path) )
      # Merging will overwrite defaults
      @@config = @@config.deep_merge( JSON.parse( File.read('./beavero_config.json'), symbolize_names: true ) )
    else
      log("Config file doesn't exist. Using defaults only.", 'warn')
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

  # deep_merge function by Dan from SO, used for merging configuration
  class ::Hash
    def deep_merge(second)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
      self.merge(second.to_h, &merger)
    end
  end
end
