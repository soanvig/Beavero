module BeaveroSlim
  require 'slim'

  def self.included(base)
    # Slim included
  end

  def self.build(config)
    check_configuration(config)
    
    layouts = search_layouts

  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:slim] = './assets/slim/'                    unless @@config[:paths][:fonts]
    @@config[:paths][:slim_layouts] = './assets/slim/layouts'     unless @@config[:paths][:slim_layouts]
    @@config[:paths][:slim_includes] = ['./assets/slim/partials'] unless @@config[:paths][:slim_includes]

    @@config[:slim] = {}                                           unless @@config[:slim]

    # Slim
    Slim::Engine.options[:include_dirs] = @@config[:paths][:slim_includes]
  end

  def search_layouts
    files = Dir.glob( File.join( 
      @@config[:paths][:app], 
      @@config[:paths][:slim_layouts],
      '**',
      '*.slim' 
    ) )

    layouts = {}
    files.each do |path|
      name = File.basename(path, '.slim')
      layouts[name] = path
    end

    layouts
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
