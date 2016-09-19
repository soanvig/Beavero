module BeaveroUglifier
  require 'uglifier'

  def self.included(base)
    # Uglifier included
  end

  def self.build(config)
    check_configuration(config)

    files = search_files
    files_content = files.map { |file| File.read(file) }

    # If combine then:
    # - change files to combine name file to mimic one file 
    # - combine content of all files
    if @@config[:js][:combine]
      files = [ @@config[:js][:combine_name] ]
      files_content = [files_content.join(' ')]

      Beavero.log("Uglifier: All files combined.", 'info')
    end

    files.each_with_index do |file, index|
      filename = File.basename(file, '.*')
      output = Uglifier.compile( files_content[index] )

      target = File.join( @@config[:paths][:app], @@config[:paths][:output], filename + '.min' + '.js' )

      File.write( target, output, { mode: 'a' } )

      Beavero.log("Uglifier: '" + File.basename(file).italic + "' uglified.", 'info')
    end

    Beavero.log("Uglifier builded successfully!", 'success')
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    config = {
      paths: {
        js: './assets/js/',
        slim_layouts: './assets/slim/layouts/',
        slim_includes: './assets/slim/partials/'
      },
      js: {
        combine: false,
        combine_name: 'app'
      }
    }

    @@config = config.deep_merge( @@config )
  end

  def self.search_files
    dir = File.join( @@config[:paths][:app], @@config[:paths][:js] )

    Dir.glob( File.join( dir, '**/*.js' ) )
  end
end
