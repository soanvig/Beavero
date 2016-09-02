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
      FileUtils.mv( file, File.join( @@config[:paths][:output], name) )
      Beavero.log("Fonts: '" + name.italic + "' moved.", 'info')
    end

    Beavero.log("Fonts builded successfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:fonts] = './assets/fonts/' unless @@config[:paths][:fonts]

    @@config[:fonts] = {}                         unless @@config[:fonts]
    @@config[:fonts][:ext] = ['ttf', 'TTF', 'eot', 'eot', 'woff', 'WOFF', 'woff2', 'WOFF2', 'svg', 'SVG', 'ttc', 'TTC']
  end
end
