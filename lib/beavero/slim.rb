module BeaveroSlim
  require 'slim'
  
  def self.included(base)
    # Slim included
  end

  def self.build(config)
    check_configuration(config)
    
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:slim] = './assets/slim/'                unless @@config[:paths][:fonts]
    @@config[:paths][:slim_layouts] = './assets/slim/layouts' unless @@config[:paths][:slim_layouts]

    @@config[:slim] = {}                                       unless @@config[:slim]
  end

  # Enviroment class is required to provide support for content_for (and yielding specific block of codes)
  class Enviroment 
    def initialize
      @vars = {}
    end

    def content_for(key)  
      @vars[key] = yield

      # Return nil so Slim doesn't render block content once more
      return nil
    end

    def [](key)
      @vars[key]
    end
  end
end
