module WS2801
	class Instance
		def initialize
			@options = {
				len: 25,
				strip: [],
				device: "/dev/spidev0.0",
				autowrite: true
			}
		end
		
		# Set/read length of strip
		# 
		# Example:
		#   >> WS2801.length(25)
		#   >> WS2801.length
		#   => 25
		# 
		# Arguments (or nil):
		#   count: (Integer)
		def length len = nil
			return @options[:len] if len.nil?
			@options[:len] = len
		end
		
		# Set/read device
		# 
		# Example:
		#   >> WS2801.device("/dev/spidev0.0")
		#   >> WS2801.device
		#   => "/dev/spidev0.0"
		# 
		# Arguments (or nil):
		#   device: (String)
		def device dev = nil
			return @options[:device] if dev.nil?
			@options[:device] = dev
		end
		
		# Set/read current Strip
		# 
		# Example;
		#   >> WS2801.strip
		#   >> WS2801.strip @newstrip
		def strip strip = nil
			return @options[:strip] if strip.nil?
			@options[:strip] = strip
		end
		
		# Set/read current Autowrite option
		# Write after each set (default: true)
		# 
		# Example;
		#   >> WS2801.autowrite
		#   >> WS2801.autowrite @newstrip
		def autowrite autowrit = nil
			return @options[:autowrite] if autowrit.nil?
			@options[:autowrite] = autowrit
		end
		
		# Generate empty strip array
		# 
		# Example:
		#   >> WS2801.generate
		def generate
			@options[:strip] = Array.new(@options[:len]*3+1) { 0 }
		end
		
		# Write colors to the device
		# (this needs root rights)
		# 
		# Example:
		#   >> WS2801.write
		def write
			return false if @options[:strip].nil?
			
			@options[:strip].each_with_index do |s,i|
				@options[:strip][i] = 0 if @options[:strip][i].nil?
			end
			
			File.open(@options[:device], 'w') do |file|
				file.write(@options[:strip].pack('C*'))
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
		def set options = {}
			self.generate if @options[:strip].length == 0
			options[:pixel] = (0..(self.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
			options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
			options[:pixel].each do |i|
				@options[:strip][(i*3)]   = options[:r] || 0
				@options[:strip][(i*3)+1] = options[:g] || 0
				@options[:strip][(i*3)+2] = options[:b] || 0
			end
			self.write if @options[:autowrite]
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
		def fade options = {}
			self.generate if @options[:strip].length == 0
			options[:pixel] = (0..(self.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
			options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
			options[:r] = 0 if options[:r].nil?
			options[:g] = 0 if options[:g].nil?
			options[:b] = 0 if options[:b].nil?
			
			while true
				options[:pixel].each do |i|
					#next if @options[:strip][(i*3+2)] == options[:b] and @options[:strip][(i*3+1)] == options[:g] and @options[:strip][(i*3)] == options[:r]
					if @options[:strip][(i*3)]   > options[:r]
						@options[:strip][(i*3)]   -= 1
					elsif @options[:strip][(i*3)]   < options[:r]
						@options[:strip][(i*3)]   += 1
					end
					if @options[:strip][(i*3+1)] > options[:g]
						@options[:strip][(i*3+1)] -= 1
					elsif @options[:strip][(i*3+1)] < options[:g]
						@options[:strip][(i*3+1)] += 1
					end
					if @options[:strip][(i*3+2)] > options[:b]
						@options[:strip][(i*3+2)] -= 1
					elsif @options[:strip][(i*3+2)] < options[:b]
						@options[:strip][(i*3+2)] -= 1
					end
				end
				(breakme = true; break) if @options[:strip][(i*3+2)] == options[:b] and @options[:strip][(i*3+1)] == options[:g] and @options[:strip][(i*3)] == options[:r]
				self.write if @options[:autowrite]
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
		def get pixel
			[@options[:strip][pixel*3], @options[:strip][pixel*3+1], @options[:strip][pixel*3+2]]
		end
		
		# Set off
		# 
		# Example:
		#   >> WS2801.off
		def off
			self.generate
			self.write if @options[:autowrite]
		end
	end
end