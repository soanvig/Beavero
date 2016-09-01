module BeaveroVendor
  def self.included(base)
    # Vendor included
  end

  def self.build(config)
    check_configuration(config)

    source = File.join( @@config[:paths][:app], @@config[:paths][:vendor] )
    target = File.join( @@config[:paths][:app], @@config[:paths][:output] )
    FileUtils.copy_entry( source, target )

    Beavero.log("Static builded sucessfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:vendor] = './vendor/' unless @@config[:paths][:vendor]
  end
end
