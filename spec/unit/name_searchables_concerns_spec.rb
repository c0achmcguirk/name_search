require 'spec_helper'

describe NameSearch::NameSearchablesConcerns do
  describe 'update_name_searchables' do
    before :all do
      Customer.skip_callback(:save, :after, :sync_name_searchables)
    end

    after :all do
      Customer.set_callback(:save, :after, :sync_name_searchables)
    end

    def new_customer(name)
      @customer = Customer.create! :name => name
      @customer.update_name_searchables
    end

    def customer_name_values(force_reload = false)
      @customer.name_searchables(force_reload).map{|x| x.name.value }
    end

    specify 'first name' do
      new_customer('Paul')
      customer_name_values.should include('paul')
    end

    specify 'first and last name' do
      new_customer('Paul Yoder')
      customer_name_values.should include('paul', 'yoder')
    end

    specify 'first, spouse and last name' do
      new_customer('Paul and Jen Yoder')
      customer_name_values.should include('paul', 'jen', 'yoder')
    end

    specify 'last, first' do 
      new_customer('Yoder, Paul')
      customer_name_values.should include('paul', 'yoder')
    end

    specify 'hyphenated last name is split in 2' do
      new_customer('Sue Smith-Harrison')
      customer_name_values.should include('sue', 'smith', 'harrison')
    end

    context 'should not include' do
      specify '","' do
        new_customer('Yoder, Paul')
        customer_name_values.should_not include('yoder,')
      end

      specify '";"' do
        new_customer('Paul Yoder;,')
        customer_name_values.should_not include('yoder;,')
        customer_name_values.should include('yoder')
      end

      specify '"and"' do
        new_customer('Paul And Jen Yoder')
        customer_name_values.should_not include('and')
      end

      specify '"&"' do
        new_customer('Paul & Jen Yoder')
        customer_name_values.should_not include('&')
      end

      specify '"or"' do
        new_customer('Paul or Jen Yoder')
        customer_name_values.should_not include('or')
      end
    end
    context 'on multiple attributes' do
      it 'saves name values on each attribute' do
        user = User.create! :first_name => 'Paul', :last_name => 'Yoder'
        user.name_searchables(true).map{|x| x.name.value }.should include('paul', 'yoder')
      end
    end
    context 'when name changes' do
      it 'does not re-add name values that did not change' do
        new_customer('Jen York')
        @customer.name = 'Jen Yoder'
        @customer.update_name_searchables
        customer_name_values.count('jen').should == 1
      end
      it 'deletes name values that no longer exist' do
        new_customer('Jen York')
        @customer.name = 'Jen Yoder'
        @customer.update_name_searchables
        customer_name_values(true).should_not include('york')
      end
    end
  end

  describe 'sync_name_searchables' do
    it 'is set as an after save callback' do
      Customer._save_callbacks.any?{|callback| callback.kind == :after &&
                                               callback.filter = :sync_name_searchables}.should be_true
    end
  end

  describe 'name_search_attributes_changed?' do
    it 'returns true when a name_search attribute is changed' do
      customer = Customer.create! :name => 'Paul'
      customer.name = 'Ben'
      customer.name_search_attributes_changed?().should be_true
    end
    it 'returns false when a name_search attribute is not changed' do
      customer = Customer.create! :name => 'Paul', :state => 'IN'
      customer.state = 'NE'
      customer.name_search_attributes_changed?().should be_false
    end
  end

  describe 'name_searchable_values' do
    it 'maps name_searchbles.name.value' do
      c = Customer.create! :name => 'Paul Yoder'
      c.name_searchable_values.should include('paul', 'yoder')
    end
  end
end
