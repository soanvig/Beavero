module BeaveroImages
  require 'image_optim'
  require 'image_optim_pack'

  def self.included(base)
    # Images included
  end

  def self.build(config)
    check_configuration(config)
    image_optim = ImageOptim.new({ 
      pngout: false, 
      svgo: false, 
      cache_dir: '/tmp/',
      pngquant: false,
      pngcrush: false,
      optipng: false
    })
    
    images = search_files
    target = File.join( @@config[:paths][:app], @@config[:paths][:output] )
    output = []
   
    if @@config[:images][:compress]
      image_optim.optimize_images(images) do |unoptimized, optimized|
        name = File.basename(unoptimized)
        image = optimized ? optimized : unoptimized
        FileUtils.cp( image, File.join( target, name) )

        if optimized
          Beavero.log("Images: '" + name.italic + "' compressed.", 'info')
        else
          Beavero.log("Images: '" + name.italic + "' moved (not compressed).", 'info')
        end
      end
    else
      images.each do |image|
        name = File.basename(image)
        FileUtils.cp( image, File.join( target, name) )
        Beavero.log("Images: '" + name.italic + "' moved (not compressed).", 'info')
      end
    end

    Beavero.log("Images builded sucessfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:images] = './assets/images/' unless @@config[:paths][:images]

    @@config[:images] = {}                         unless @@config[:images]
    @@config[:images][:ext] = ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG', 'svg', 'SVG', 'gif', 'GIF']
    @@config[:images][:compress] = false           unless @@config[:images][:compress]
  end

  def self.search_files
    images_path = File.join( @@config[:paths][:app], @@config[:paths][:images] )
    images = Dir.glob( File.join( images_path, '**', '*' ) + '.{' + @@config[:images][:ext].join(',') + '}' )
    images
  end
end
