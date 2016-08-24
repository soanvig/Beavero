module BeaveroUglifier
  require 'uglifier'

  def self.included(base)
    # Uglifier included
  end

  def self.build(config)
    check_configuration(config)

    files = search_files
    full_output = {}

    files.each do |file|
      filename = File.basename(file, '.*')
      content = File.read(file)
      output = Uglifier.compile(content)

      full_output[filename] = output
    end

    full_output.each do |filename, output|
      target = if @@config[:js][:combine]
        File.join( @@config[:paths][:app], @@config[:paths][:output], @@config[:js][:combine_name] + '.min' + '.js' )
      else
        File.join( @@config[:paths][:app], @@config[:paths][:output], filename + '.min' + '.js' )
      end

      File.write( target, output, { mode: 'a' } )
    end
  end

  private

  def self.check_configuration(config)
    @@config = config

    # Defaults
    @@config[:paths][:js] = './assets/js/' unless @@config[:paths][:js]

    @@config[:js] = {}                      unless @@config[:js]
    @@config[:js][:combine] = false         unless @@config[:js][:combine]
    @@config[:js][:combine_name] = 'app'    unless @@config[:js][:combine_name]
  end

  def self.search_files
    dir = File.join( @@config[:paths][:app], @@config[:paths][:js] )

    Dir.glob( File.join( dir, '**/*.js' ) )
  end
end
