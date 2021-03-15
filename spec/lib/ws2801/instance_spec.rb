require 'spec_helper'

RSpec.describe WS2801::Instance do
	let(:default_instance) { WS2801::Instance.new }
	
	describe '.new' do
		it 'accepts parameters' do
			instance = WS2801::Instance.new(length: 10, strip: [1,2,3], device: 'test_asdf', autowrite: false)
			
			expect(instance.length   ).to eq 10
			expect(instance.strip    ).to eq [1,2,3]
			expect(instance.device   ).to eq 'test_asdf'
			expect(instance.autowrite).to eq false
		end
	end
	
	describe '#length' do
		it 'has a default value' do
			expect(default_instance.length).to eq 25
		end
		
		it 'can be set' do
			default_instance.length = 20
			
			expect(default_instance.length).to eq 20
		end
	end
	
	describe '#strip' do
		it 'has a default value' do
			expect(default_instance.strip).to eq []
		end
		
		it 'can be set' do
			default_instance.strip = [0,0,0,0]
			
			expect(default_instance.strip).to eq [0,0,0,0]
		end
	end
	
	describe '#device' do
		it 'has a default value' do
			expect(default_instance.device).to eq '/dev/spidev0.0'
		end
		
		it 'can be set' do
			default_instance.device = '/dev/spidev0.1'
			
			expect(default_instance.device).to eq '/dev/spidev0.1'
		end
	end
	
	describe '#autowrite' do
		it 'has a default value' do
			expect(default_instance.autowrite).to eq true
		end
		
		it 'can be set' do
			default_instance.autowrite = false
			
			expect(default_instance.autowrite).to eq false
		end
	end
	
	describe '#generate' do
		it 'generates strip values' do
			default_instance.generate
			
			expect(default_instance.strip.length).to eq 3*25+1
			expect(default_instance.strip       ).to all(be 0)
		end
		
		it 'accepts a parameter "only_if_empty"' do
			default_instance.length = 2
			
			expect{default_instance.generate(only_if_empty: false)}.    to change{default_instance.strip}.from([]).to([0,0,0,0,0,0,0])
			
			default_instance.length = 1
			
			expect{default_instance.generate(only_if_empty: true )}.not_to change{default_instance.strip}
			
			default_instance.strip = []
			
			expect{default_instance.generate(only_if_empty: true )}.    to change{default_instance.strip}.from([]).to([0,0,0,0])
		end
	end
end