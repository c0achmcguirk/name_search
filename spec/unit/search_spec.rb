require 'spec_helper'

describe NameSearch::Search do
	it 'should exist' do
		defined?(NameSearch::Search).should be_true
	end	

	it 'should inherit from Array' do
		NameSearch::Search.ancestors.second.should == Array
	end

	describe '.initialize' do
		def search(klass, name)
			NameSearch::Search.new(klass, name)
		end

		before :all do
			Customer.destroy_all
			Customer.create! :name => 'Paul'
			Customer.create! :name => 'Paul'
			Customer.create! :name => 'Ben Miller'
			Customer.create! :name => 'Ben Miller'
			Customer.create! :name => 'Benjamin'
			Customer.create! :name => 'Fred Flintstone'
			Customer.create! :name => 'Fred Smith'
			Customer.create! :name => 'Fred Samuel Smith'

			NameSearch::Name.relate_nick_names('benjamin', 'ben')
		end
			
		context 'single name' do
			it 'should return models with exact same names' do
				results = search(Customer, 'paul')
				results.select{|x| x.name == 'Paul'}.length.should == 2
			end
		end

		context 'multiple names' do
			it 'should return models with exact same names' do
				results = search(Customer, 'ben miller')
				results.select{|x| x.name == 'Ben Miller'}.length.should == 2
			end

			it 'should return models with same first name' do
				results = search(Customer, 'fred')
				results.select{|x| x.name =~ /Fred/}.length.should == 3
			end

			it 'should sort returned models by number of name matches' do
				results = search(Customer, 'Fred Samuel Smith')
				results.length.should == 3
				results.index{|x| x.name == 'Fred Samuel Smith'}.should == 0
			end
		end

		context 'nicknames' do
			it 'should return models in same nick name family' do
				search(Customer, 'ben').select{|x| x.name == 'Benjamin'}.length.should == 1
			end

			it 'should return exact matches before nick name matches' do
				results = search(Customer, 'benjamin')
				ben_result_index = results.index{|x| x.name == 'Ben Miller'}
				benjamin_result_index = results.index{|x| x.name == 'Benjamin'}
				benjamin_result_index.should be < ben_result_index
			end
		end

		context 'should parse the names argument correctly' do
			it 'should filter out non-alpha-numeric characters' do
				results = search(Customer, 'miller,')
				results.select{|x| x.name =~ /Miller/}.length.should == 2
			end
		end
	end
end