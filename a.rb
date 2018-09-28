class Foo
	def bar
		p 'inside bar'
	end
	private
		def privbar
			p 'private'
		end
end

Foo.new.instance_eval do 
	bar
	privbar
end
