module BeaveroStatic
  def self.included(base)
    # Static included
  end

  def self.build(config)
    source = File.join( config[:paths][:app], config[:paths][:static] )
    target = File.join( config[:paths][:app], config[:paths][:output] )
    FileUtils.copy_entry( source, target )
  end
end
