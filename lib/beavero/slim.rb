module BeaveroSlim
  def self.included(base)
    # Slim included
  end

  def self.build(config)
    check_configuration(config)
    
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:slim] = './assets/slim/'                unless @@config[:paths][:fonts]
    @@config[:paths][:slim_layouts] = './assets/slim/layouts' unless @@config[:paths][:slim_layouts]

    @@config[:slim] = {}                                       unless @@config[:slim]
  end
end
