module BeaveroSlim
  require 'slim'

  def self.included(base)
    # Slim included
  end

  def self.build(config)
    check_configuration(config)
    
    layouts = search_layouts
    files = search_files

    files.each do |file|
      enviroment = Enviroment.new(@@config)

      # Render file content with enviroment
      content = Slim::Template.new { File.read(file) }.render(enviroment)
      # Prepare layout with given layout name
      layout = Slim::Template.new { File.read( layouts[enviroment.layout] ) }

      # Render layout with enviroment blocks
      output = layout.render do |key|
        key ? enviroment[key] : content
      end

       # Save file
      name = File.basename(file, '.slim')
      target = File.join( @@config[:paths][:app], @@config[:paths][:output], name + '.html' )
      File.write(target, output)

      Beavero.log("Slim: '" + (name + '.slim').italic + "' file compiled with '" + (enviroment.layout + '.slim').italic + "' layout.", 'info')
    end

    Beavero.log("Slim builded successfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    config = {
      paths: {
        slim: './assets/slim/',
        slim_layouts: './assets/slim/layouts/',
        slim_includes: './assets/slim/partials/'
      },
      slim: {
        compress: true
      }
    }

    @@config = config.deep_merge( @@config )

    # Slim configuration
    Slim::Engine.options[:pretty] = !@@config[:slim][:compress] # invertion of option
  end

  def self.search_layouts
    files = Dir.glob( File.join( 
      @@config[:paths][:app], 
      @@config[:paths][:slim_layouts],
      '**',
      '*.slim' 
    ) )

    # Save layouts in hash {layout_name: layout_absolute_path}
    layouts = {}
    files.each do |path|
      name = File.basename(path, '.slim')
      layouts[name] = path
    end

    Beavero.log("Slim: Layouts found: '[" + files.join(',').italic + "]'", 'debug')

    layouts
  end

  def self.search_files
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
      includes_path = File.join( @@config[:paths][:app], @@config[:paths][:slim_includes] ) 

      # We need to search and compare each path (they have to be exact)
      # if at least one matching path found - exclude that file
      ([layouts_path] + [includes_path]).find { |el| File.realdirpath(el) === File.realdirpath(dir) }
    end

    Beavero.log("Slim: Files found to build: '[" + files.join(',').italic + "]'", 'debug')

    files
  end

  # Enviroment class is required to provide support for content_for (and yielding specific block of codes), and include
  class Enviroment 
    attr_reader :layout

    def initialize(config)
      @vars = {}
      @config = config
    end

    def content_for(key)  
      @vars[key] = yield

      # Return nil so Slim doesn't render block content twice
      return nil
    end

    def [](key)
      @vars[key]
    end

    def layout_name(name)
      @layout = name
    end

    def include(name)
      # Search recursively for file in include path
      filepath = File.join(
          @config[:paths][:app],
          @config[:paths][:slim_includes],
          name
        )

      if File.exist? filepath
        ext = File.extname(name)

        # If file has .slim extension it needs to be parsed, otherwised not
        if ext == '.slim'
          Beavero.log("Slim: '" + name.italic + "' included and rendered.", 'debug')
          return Slim::Template.new { File.read(filepath) }.render
        else
          Beavero.log("Slim: '" + name.italic + "' included.", 'debug')
          return File.read(filepath)
        end
      else
        Beavero.log("Slim: Couldn't include '" + name.italic + "' file.", 'warn')
        return nil
      end
    end
  end
end
