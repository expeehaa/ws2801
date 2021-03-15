module WS2801
	class Instance
		attr_accessor :length
		attr_accessor :strip
		attr_accessor :device
		attr_accessor :autowrite
		
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
				self.strip = Array.new(self.length*3+1) { 0 }
			end
		end
		
		# Write colors to the device
		# (this needs root rights)
		# 
		# Example:
		#   >> WS2801.write
		def write(only_if_autowrite: false)
			if !only_if_autowrite || self.autowrite
				return false if self.strip.nil?
				
				self.strip.each_with_index do |s,i|
					self.strip[i] = 0 if self.strip[i].nil?
				end
				
				File.open(self.device, 'w') do |file|
					file.write(self.strip.pack('C*'))
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
		def set(options = {})
			self.generate(only_if_empty: true)
			
			options[:pixel] = (0..(self.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
			options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
			options[:pixel].each do |i|
				self.strip[(i*3)]   = options[:r] || 0
				self.strip[(i*3)+1] = options[:g] || 0
				self.strip[(i*3)+2] = options[:b] || 0
			end
			
			self.write(only_if_autowrite: true)
		end
		
		# Fade pixel to color
		# 
		# Example:
		#   >> WS2801.set { r: 255, pixel: [1..10], timeout: 0.1 }
		#   >> WS2801.set { g: 128, pixel: :all }
		#   >> WS2801.set { r: 40, g: 255, b: 200, pixel: 4 }
		# 
		# Options:
		#   pixel: []      # array with pixel ids
		#   timeout: (Float)
		#   r: (Integer)
		#   g: (Integer)
		#   b: (Integer)
		def fade(options = {})
			self.generate(only_if_empty: true)
			
			options[:pixel] = (0..(self.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
			options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
			options[:r] = 0 if options[:r].nil?
			options[:g] = 0 if options[:g].nil?
			options[:b] = 0 if options[:b].nil?
			
			while true
				options[:pixel].each do |i|
					#next if self.strip[(i*3+2)] == options[:b] and self.strip[(i*3+1)] == options[:g] and self.strip[(i*3)] == options[:r]
					if self.strip[(i*3)]   > options[:r]
						self.strip[(i*3)]   -= 1
					elsif self.strip[(i*3)]   < options[:r]
						self.strip[(i*3)]   += 1
					end
					if self.strip[(i*3+1)] > options[:g]
						self.strip[(i*3+1)] -= 1
					elsif self.strip[(i*3+1)] < options[:g]
						self.strip[(i*3+1)] += 1
					end
					if self.strip[(i*3+2)] > options[:b]
						self.strip[(i*3+2)] -= 1
					elsif self.strip[(i*3+2)] < options[:b]
						self.strip[(i*3+2)] -= 1
					end
				end
				(breakme = true; break) if self.strip[(i*3+2)] == options[:b] and self.strip[(i*3+1)] == options[:g] and self.strip[(i*3)] == options[:r]
				
				self.write(only_if_autowrite: true)
				
				break if breakme
				
				sleep(options[:timeout] || 0.01)
			end
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
			[self.strip[pixel*3], self.strip[pixel*3+1], self.strip[pixel*3+2]]
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
