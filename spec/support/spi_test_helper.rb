class SPIMock
	attr_accessor :speed
	
	def initialize(device:)
		@device = device
	end
	
	def xfer(txdata:)
		@written_data = txdata
	end
end

RSpec.configure do |c|
	c.before(:each, :mock_spi) do
		stub_const('SPI', SPIMock)
	end
end