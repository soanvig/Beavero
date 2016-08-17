module BeaveroVendor
  def self.included(base)
    # Vendor included
  end

  def self.build(config)
    source = File.join( config[:paths][:app], config[:paths][:vendor] )
    target = File.join( config[:paths][:app], config[:paths][:output] )
    FileUtils.copy_entry( source, target )
  end
end
