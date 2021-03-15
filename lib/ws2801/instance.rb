require_relative 'effects/fade'
require_relative 'effects/pulse'
require_relative 'effects/stroboscope'

module WS2801
	class Instance
		attr_accessor :length
		attr_accessor :strip
		attr_accessor :device
		attr_accessor :autowrite
		
		include WS2801::Effects::Fade
		include WS2801::Effects::Pulse
		include WS2801::Effects::Stroboscope
		
		def initialize(length: 25, strip: [], device: '/dev/spidev0.0', autowrite: true)
			self.length    = length
			self.strip     = strip
			self.device    = device
			self.autowrite = autowrite
		end
		
		# Generate empty strip array
		# 
		# Example:
		#   >> WS2801.generate
		def generate(only_if_empty: false)
			if !only_if_empty || self.strip.length == 0
				self.strip = Array.new(self.length*3) { 0 }
			end
		end
		
		# Write colors to the device
		# (this needs root rights)
		# 
		# Example:
		#   >> WS2801.write
		def write(only_if_autowrite: false)
			if !only_if_autowrite || self.autowrite
				File.open(self.device, 'w') do |file|
					file.write((self.strip+[0]).pack('C*'))
				end
			else
				false
			end
		end
		
		# Set pixel to color
		# 
		# Example:
		#   >> WS2801.set { r: 255, pixel: [1..10] }
		#   >> WS2801.set { g: 128, pixel: :all }
		#   >> WS2801.set { r: 40, g: 255, b: 200, pixel: 4 }
		# 
		# Options:
		#   pixel: []      # array with pixel ids
		#   r: (Integer)
		#   g: (Integer)
		#   b: (Integer)
		def set(pixel: 0...self.length, r: 0, g: 0, b: 0)
			self.generate(only_if_empty: true)
			
			pixel = [pixel] if pixel.is_a? Numeric
			
			pixel.each do |i|
				self.strip[(i*3)..(i*3+2)] = [r,g,b]
			end
			
			self.write(only_if_autowrite: true)
		end
		
		# Get Pixel
		# 
		# Example:
		#   >> WS2801.get 1
		#   => [255,0,0]
		# 
		# Arguments:
		#   pixel - Pixel id
		def get(pixel)
			self.strip[(pixel*3)..(pixel*3+2)]
		end
		
		# Set off
		# 
		# Example:
		#   >> WS2801.off
		def off
			self.generate
			
			self.write(only_if_autowrite: true)
		end
	end
end
