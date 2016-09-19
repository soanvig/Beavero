module BeaveroFonts
  def self.included(base)
    # Fonts included
  end

  def self.build(config)
    check_configuration(config)
    
    # List files without directories
    files = Dir.glob( File.join( 
      @@config[:paths][:app], 
      @@config[:paths][:fonts], 
      '**', 
      '*' + '.{' + @@config[:fonts][:ext].join(',') + '}' 
    ) )
    files = files.reject do |path|
      File.directory? path
    end

    # Copy everything
    files.each do |file|
      name = File.basename(file)
      FileUtils.cp( file, File.join( @@config[:paths][:output], name) )
      Beavero.log("Fonts: '" + name.italic + "' moved.", 'info')
    end

    Beavero.log("Fonts builded successfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    config = {
      paths: {
        fonts: './assets/fonts/'
      },
      fonts: {
        ext: ['ttf', 'TTF', 'eot', 'eot', 'woff', 'WOFF', 'woff2', 'WOFF2', 'svg', 'SVG', 'ttc', 'TTC', 'otf', 'OTF'],
      }
    }

    @@config = config.deep_merge( @@config )
  end
end
