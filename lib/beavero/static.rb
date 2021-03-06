module BeaveroStatic
  def self.included(base)
    # Static included
  end

  def self.build(config)
    check_configuration(config)

    source = File.join( @@config[:paths][:app], @@config[:paths][:static] )
    target = File.join( @@config[:paths][:app], @@config[:paths][:output] )
    FileUtils.copy_entry( source, target )

    Beavero.log("Static builded sucessfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    config = {
      paths: {
        static: './static/',
      }
    }

    @@config = config.deep_merge( @@config )
  end
end
