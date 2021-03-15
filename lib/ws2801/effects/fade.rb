module WS2801
	module Effects
		module Fade
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
				self.resize_strip
				
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
		end
	end
end