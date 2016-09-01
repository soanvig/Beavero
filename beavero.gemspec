Gem::Specification.new do |s|
  s.name        = 'Beavero'
  s.version     = '0.4.1'
  s.summary     = 'Beavero - Ruby tasker programmed for webdevelopment'
  s.description = 'Beavero - Ruby tasker programmed for webdevelopment. This is pre-release version!
  More information on https://github.com/soanvig/beavero'
  s.author      = 'Schizohatter'
  s.email       = 'soanvig@gmail.com'
  s.files       = ['lib/beavero.rb', 'lib/beavero/static.rb', 'lib/beavero/vendor.rb', 'lib/beavero/sass.rb', 'lib/beavero/uglifier.rb']
  s.homepage    = 'https://github.com/soanvig/beavero'
  s.license     = 'MIT'
  s.add_runtime_dependency 'logger'
  s.add_runtime_dependency 'colorize', '>= 0.8.1'
  s.add_runtime_dependency 'sass', '>= 3.4.22'
  s.add_runtime_dependency 'uglifier', '>= 3.0.2'
end
