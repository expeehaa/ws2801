module WS2801
	module Effects
		module Stroboscope
			# Stroboscope effect
			# 
			# Example:
			#   >> WS2801E.stroboscope({ timeout: 0.25, times: 22, r: 255 })
			#   >> WS2801E.stroboscope({ b: 255, g: 255 })
			# 
			# Arguments (or nil):
			#   pixel: (Number-Array|Integer|:all)
			#   r: (Integer) 0-255 red
			#   g: (Integer) 0-255 green
			#   b: (Integer) 0-255 blue
			#   timeout: (Float)
			#   times: (Integer)
			def stroboscope options = {}
				options[:pixel] = (0..(self.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
				options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
				options[:r] = 0 if options[:r].nil?
				options[:g] = 0 if options[:g].nil?
				options[:b] = 0 if options[:b].nil?
				options[:times] = options[:times].to_i if !options[:times].is_a? Numeric
				options[:times] = 40 if options[:times] == 0
				options[:timeout] = options[:timeout].to_f
				options[:timeout] = 0.03 if options[:timeout] == 0.0
				
				breakme = 0
				options[:times].times do |c|
					if c % 2 == 0
						r = 0
						g = 0
						b = 0
					else
						r = options[:r]
						g = options[:g]
						b = options[:b]
					end
					self.set({
						pixel: options[:pixel],
						r: r,
						g: g,
						b: b
					})
					sleep( options[:timeout] )
				end
			end
		end
	end
end