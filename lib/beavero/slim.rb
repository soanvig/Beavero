module BeaveroSlim
  require 'slim'
  require 'slim/include'

  def self.included(base)
    # Slim included
  end

  def self.build(config)
    check_configuration(config)
    
    layouts = search_layouts
    files = search_files
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:slim] = './assets/slim/'                    unless @@config[:paths][:fonts]
    @@config[:paths][:slim_layouts] = './assets/slim/layouts'     unless @@config[:paths][:slim_layouts]
    @@config[:paths][:slim_includes] = ['./assets/slim/partials'] unless @@config[:paths][:slim_includes]

    @@config[:slim] = {}                                          unless @@config[:slim]

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

  def search_files
    # Get all slim files
    files = Dir.glob( File.join( 
      @@config[:paths][:app],
      @@config[:paths][:slim],
      '**',
      '*.slim'
    ) )

    # Exclude files contained in includes and layouts directory
    files = files.reject do |path|
      dir = File.dirname(path)
      layouts_path = File.join( @@config[:paths][:app], @@config[:paths][:slim_layouts] )
      includes_path = @@config[:paths][:slim_includes].map { |x| File.join( @@config[:paths][:app], x ) }

      (layouts_path + includes_path).include? dir
    end
  end

  # Enviroment class is required to provide support for content_for (and yielding specific block of codes)
  class Enviroment 
    attr_reader :layout

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

    def layout_name(name)
      @layout = name
    end
  end
end
