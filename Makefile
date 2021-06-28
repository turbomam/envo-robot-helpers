.PHONY: nmdc_envo_id_range.tsv find_last_in_range.tsv

# requires that the google sheet is set to public sharing
current_robot_gsheet='https://docs.google.com/spreadsheets/d/1hk7p5MdjRqjP1P3-0zBmIzsfjoOkziY7uuLFxYH1jKU/export?gid=0&format=csv'

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

# make sure you have a local clone of https://github.com/EnvironmentOntology/envo
# that you have created an issue and corresponding branch
# your branch is up-to-date with main
# and you are checked-out into the appropriate branch
# overwrites by default
../envo/src/envo/modules/temporary_robot_template.csv:
	wget --no-check-certificate -O $@ $(current_robot_gsheet)

../envo/src/envo/modules/temporary_robot_template.owl: ../envo/src/envo/modules/temporary_robot_template.csv
	robot template \
	  --template ../envo/src/envo/modules/temporary_robot_template.csv \
	  -i ../envo/src/envo/envo-edit.owl \
	  --prefix "RO:http://purl.obolibrary.org/obo/RO_" \
	  --prefix "ENVO:http://purl.obolibrary.org/obo/ENVO_"  \
	  --ontology-iri "http://purl.obolibrary.org/envo/modules/temporary_robot_template.owl" \
	  convert \
	  --format ofn \
	  -o $@

../envo/src/envo-edit.owl: ../envo/src/envo/modules/temporary_robot_template.owl
	robot merge \
	  --input $@ \
	  --input ../envo/src/modules/temporary_robot_template.owl \
	  --collapse-import-closure false \
	  convert \
	  --format ofn \
	  --output $@

