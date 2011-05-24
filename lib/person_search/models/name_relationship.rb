module PersonSearch
	class NameRelationship < ActiveRecord::Base
		set_table_name :person_search_name_relationships

		has_many :names
	end
end
