module PersonSearch
	class NamePersonJoin < ActiveRecord::Base
		set_table_name :person_search_name_person_joins

		belongs_to :name
	end
end
