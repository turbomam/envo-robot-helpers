.PHONY: nmdc_envo_id_range.tsv find_last_in_range.tsv

current_robot_gsheet=https://docs.google.com/spreadsheets/d/1hk7p5MdjRqjP1P3-0zBmIzsfjoOkziY7uuLFxYH1jKU/export?gid=0&format=csv

nmdc_envo_id_range.tsv:
	robot query \
	  --input-iri https://raw.githubusercontent.com/EnvironmentOntology/envo/master/src/envo/envo-idranges.owl \
	  --query nmdc_envo_id_range.rq nmdc_envo_id_range.tsv
	  
# this assumes that no nobody "else" has started to use NMDC ENVO IDs that aren't reflected in the release envo.owl
# could also check the envo_edit.owl checked in to main, or some local file
# or WE could take some responsibility for tracking our own allocation/usage
get_envo_ids.tsv:
	robot query \
	  --input-iri https://raw.githubusercontent.com/EnvironmentOntology/envo/master/envo.owl \
	  --query get_envo_ids.rq get_envo_ids.tsv

last_used_id.txt: nmdc_envo_id_range.tsv get_envo_ids.tsv
	python apply_range_to_usage.py > $@
	
current_robot_gsheet.tsv:
	# wget --no-check-certificate -O test.csv $(current_robot_gsheet)
	echo $(current_robot_gsheet)
	wget --no-check-certificate -O test.csv $(current_robot_gsheet)
