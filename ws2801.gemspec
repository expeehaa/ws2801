Gem::Specification.new do |s|
	s.name          = 'ws2801'
	s.version       = '1.1.0'
	s.date          = '2013-01-12'
	s.summary       = 'Controlling ws2801 chip from Ruby on Raspberry PI or similar (RGB LED Stripes/Pixel)'
	s.description   = 'Controlling ws2801 chip from Ruby on Raspberry PI or similar (RGB LED Stripes/Pixel)'
	s.files         = Dir['lib/**/*', 'README.md']
	s.author        = 'Roman Pramberger'
	s.email         = 'roman@pramberger.ch'
	s.homepage      = 'https://github.com/b1nary/ws2801'
	s.require_paths = ['lib']
	
	s.add_dependency 'spi'
end
