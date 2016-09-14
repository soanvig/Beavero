module BeaveroSass
  require 'sass'

  def self.included(base)
    # Sass included
  end

  def self.build(config)
    check_configuration(config)

    options = {
      syntax: @@config[:sass][:syntax].to_sym,
      style: @@config[:sass][:style].to_sym,
      load_paths: @@config[:sass][:load_paths],
      quiet: true
    }
    
    main_file_path = File.join( @@config[:paths][:app], @@config[:paths][:sass], @@config[:sass][:main_file] )
    if( File.exist? main_file_path )
      file = File.read( main_file_path )
    else
      Beavero.log("SASS: Main SCSS file '" + @@config[:sass][:main_file].italic + "' doesn't exist in '" + @@config[:paths][:sass] + "' location. Module cannot continue.", 'error')
    end

    if file
      engine = Sass::Engine.new( file, options )
      output = engine.render

      target = File.join( @@config[:paths][:app], @@config[:paths][:output], @@config[:sass][:output] + @@config[:sass][:output_ext] )
      File.write( target, output )

      Beavero.log("SASS builded successfully!", 'success')
    end
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:sass] = './assets/scss/'                              unless @@config[:paths][:sass]
    @@config[:sass] = {}                                                    unless @@config[:sass]
    @@config[:sass][:style] = 'compressed'                                  unless @@config[:sass][:style]
    @@config[:sass][:main_file] = 'main.scss'                               unless @@config[:sass][:main_file]
    # Syntax by default is defined by :main_file extension
    @@config[:sass][:syntax] = @@config[:sass][:main_file].split('.').last  unless @@config[:sass][:syntax]
    # Output filename by default is defined by :main_file name
    @@config[:sass][:output] = @@config[:sass][:main_file].split('.').first unless @@config[:sass][:output]
    @@config[:sass][:output_ext] = '.min.css'                               unless @@config[:sass][:output_ext]
    @@config[:sass][:load_paths] = [ File.join( @@config[:paths][:app], @@config[:paths][:sass] ) ]
  end
end
