Gem::Specification.new do |s|
  s.name        = 'beavero'
  s.version     = '0.7.0'
  s.summary     = 'Beavero - Ruby tasker programmed for webdevelopment'
  s.description = 'Beavero - Ruby tasker programmed for webdevelopment. This is pre-release version!
  More information on https://github.com/soanvig/beavero'
  s.author      = 'Schizohatter'
  s.email       = 'soanvig@gmail.com'
  s.files       = ['lib/beavero.rb', 'lib/beavero/static.rb', 'lib/beavero/vendor.rb', 'lib/beavero/sass.rb', 'lib/beavero/uglifier.rb', 'lib/beavero/images.rb', 'lib/beavero/slim.rb', 'lib/beavero/fonts.rb']
  s.homepage    = 'https://github.com/soanvig/beavero'
  s.license     = 'MIT'
  s.add_runtime_dependency 'logger', '>= 1.2.8'
  s.add_runtime_dependency 'colorize', '>= 0.8.1'
  s.add_runtime_dependency 'sass', '>= 3.4.22'
  s.add_runtime_dependency 'uglifier', '>= 3.0.2'
  s.add_runtime_dependency 'image_optim', '>= 0.24.0'
  s.add_runtime_dependency 'image_optim_pack', '>= 0.3.0.20160812'
  s.add_runtime_dependency 'slim', '>= 3.0.7'
end
