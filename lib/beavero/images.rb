module BeaveroImages
  require 'mini_magick'

  def self.included(base)
    # Images included
  end

  def self.build(config)
    check_configuration(config)
    
    images = search_files
    target = File.join( @@config[:paths][:app], @@config[:paths][:output] )
    
    images.each do |image|
      name = File.basename(image)

      # If thumbnails are enabled and file is contained within thumbnail directory
      if @@config[:images][:thumbnails] && is_thumbnail?(image)
        generate_thumbnail(image, name)
      end

      FileUtils.cp( image, File.join( target, name ) )
      Beavero.log("Images: '" + name.italic + "' moved (not compressed).", 'info')
    end

    Beavero.log("Images builded sucessfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    config = {
      paths: {
        images: './assets/images/'
      },
      images: {
        ext: ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG', 'svg', 'SVG', 'gif', 'GIF'],
        compress: false,
        thumbnails: false,
        thumbnails_dir: 'thumbs/',
        thumbnails_size: '150x150'
      }
    }

    @@config = config.deep_merge( @@config )
  end

  def self.search_files
    images_path = File.join( @@config[:paths][:app], @@config[:paths][:images] )
    images = Dir.glob( File.join( images_path, '**', '*' ) + '.{' + @@config[:images][:ext].join(',') + '}' )
    images
  end

  def self.is_thumbnail?(path)
    fullpath = File.join( @@config[:paths][:app], @@config[:paths][:images], @@config[:images][:thumbnails_dir] )
    File.realdirpath(path).include? ( File.realdirpath(fullpath) )
  end

  def self.generate_thumbnail(path, filename)
    image = MiniMagick::Image.open(path)
    image.resize @@config[:images][:thumbnails_size]

    name = File.basename(filename, '.*')
    ext = File.extname(filename)
    save_name = name + '.thumb' + ext

    image.write File.join( @@config[:paths][:app], @@config[:paths][:output], save_name )

    Beavero.log("Images: Thumbnails '" + save_name.italic + "' generated.", 'info')
  end
end
