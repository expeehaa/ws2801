RSpec.configure do |c|
	c.before do |example|
		case example.metadata[:file_write]
		when nil
		when String
			expect(File).    to receive(:open).with(example.metadata[:file_write], 'w').and_yield(buffer)
		else
			expect(File).not_to receive(:open)
		end
	end
end