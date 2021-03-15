require 'spec_helper'

RSpec.describe WS2801::Instance do
	let(:instance) { WS2801::Instance.new }
	
	describe '#length' do
		it 'has a default value' do
			expect(instance.length).to eq 25
		end
		
		it 'can be set' do
			instance.length = 20
			
			expect(instance.length).to eq 20
		end
	end
	
	describe '#device' do
		it 'has a default value' do
			expect(instance.device).to eq '/dev/spidev0.0'
		end
		
		it 'can be set' do
			instance.device = '/dev/spidev0.1'
			
			expect(instance.device).to eq '/dev/spidev0.1'
		end
	end
	
	describe '#generate' do
		it 'generates strip values' do
			instance.generate
			
			expect(instance.strip.length).to eq 3*25+1
			expect(instance.strip       ).to all(be 0)
		end
		
		it 'accepts a parameter "only_if_empty"' do
			instance.length = 2
			
			expect{instance.generate(only_if_empty: false)}.    to change{instance.strip}.from([]).to([0,0,0,0,0,0,0])
			
			instance.length = 1
			
			expect{instance.generate(only_if_empty: true )}.not_to change{instance.strip}
			
			instance.strip = []
			
			expect{instance.generate(only_if_empty: true )}.    to change{instance.strip}.from([]).to([0,0,0,0])
		end
	end
end