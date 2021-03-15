require 'spi'
require_relative 'effects/fade'
require_relative 'effects/pulse'
require_relative 'effects/stroboscope'

module WS2801
	class Instance
		attr_accessor :length
		attr_accessor :strip
		attr_accessor :autowrite
		
		include WS2801::Effects::Fade
		include WS2801::Effects::Pulse
		include WS2801::Effects::Stroboscope
		
		def initialize(length: 25, strip: [], device: '/dev/spidev0.0', autowrite: true)
			self.length    = length
			self.strip     = strip
			self.autowrite = autowrite
			
			reset_spi(device)
		end
		
		def device
			@spi.instance_variable_get(:@device)
		end
		
		def device=(value)
			reset_spi(value)
		end
		
		def reset_strip
			self.strip = Array.new(expected_strip_length) { 0 }
		end
		
		def resize_strip
			if self.strip.length < expected_strip_length
				self.strip.append(*Array.new(expected_strip_length-self.strip.length){ 0 })
			elsif self.strip.length > expected_strip_length
				self.strip.pop(self.strip.length-expected_strip_length)
			end
		end
		
		# Write colors to the device
		# (this needs root rights)
		# 
		# Example:
		#   >> WS2801.write
		def write(only_if_autowrite: false)
			if !only_if_autowrite || self.autowrite
				@spi.xfer(txdata: self.strip)
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
			self.resize_strip
			
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
			self.reset_strip
			
			self.write(only_if_autowrite: true)
		end
		
		private
		
		def expected_strip_length
			3*self.length
		end
		
		def reset_spi(device)
			@spi       = SPI.new(device: device)
			@spi.speed = 1000000
		end
	end
end
