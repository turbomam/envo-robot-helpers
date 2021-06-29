.PHONY: clean

# SEE https://github.com/EnvironmentOntology/envo/wiki/ENVO-Robot-template-and-merge-workflow

# requires that the google sheet is set to public sharing
current_robot_gsheet='https://docs.google.com/spreadsheets/d/12GICSjx2s3Ey0Crv9uMdkW8unt3LxPcOS2_u7EMAr38/export?gid=154764881&format=csv'

# or use the % substitution?
envo_location=../envo

clean:
	rm -f *tsv
	rm -f *csv
	rm -f $(envo_location)/src/envo/modules/temporary_robot_template*
	rm -f last_used_id.txt
	git -C $(envo_location) checkout origin/master src/envo/envo-edit.owl

# ----
# START FOR DETERMINING THE NEXT ENVO ID TO USE
# CURRENTLY HARDCODED FOR NMDC
# SEE nmdc_envo_id_range.rq

# this assumes that no nobody "else" has started to use NMDC ENVO IDs that aren't reflected in the monitored file
# check the last pushed envo_edit.owl, or the local version
# will be sensitive to which branch is locally checked out
# keep merged with master/main!
# Chris M discouraged creating any new system for granular tracking of our own allocation/usage
nmdc_envo_id_range.tsv:
	robot query \
	  --input-iri https://raw.githubusercontent.com/EnvironmentOntology/envo/master/src/envo/envo-idranges.owl \
	  --query nmdc_envo_id_range.rq nmdc_envo_id_range.tsv

get_envo_ids.tsv:
	robot query \
	  --input $(envo_location)/src/envo/envo-edit.owl \
	  --query get_envo_ids.rq get_envo_ids.tsv

last_used_id.txt: nmdc_envo_id_range.tsv get_envo_ids.tsv
	python apply_range_to_usage.py > $@

# END FOR DETERMINING THE NEXT ENVO ID TO USE
# ----

# make sure you have a local clone of https://github.com/EnvironmentOntology/envo
# that you have created an issue and corresponding branch
# your branch is up-to-date with main
# and you are checked-out into the appropriate branch
# overwrites by default

# Chris M suggests using James O's cogs
$(envo_location)/src/envo/modules/temporary_robot_template.csv:
	wget --no-check-certificate -O $@ $(current_robot_gsheet)

$(envo_location)/src/envo/modules/temporary_robot_template.owl: $(envo_location)/src/envo/modules/temporary_robot_template.csv
	robot template \
	  --template $(envo_location)/src/envo/modules/temporary_robot_template.csv \
	  -i $(envo_location)/src/envo/envo-edit.owl \
	  --prefix "RO:http://purl.obolibrary.org/obo/RO_" \
	  --prefix "ENVO:http://purl.obolibrary.org/obo/ENVO_"  \
	  --ontology-iri "http://purl.obolibrary.org/envo/modules/temporary_robot_template.owl" \
	  convert \
	  --format ofn \
	  -o $@

$(envo_location)/src/envo/envo-edit.owl: $(envo_location)/src/envo/modules/temporary_robot_template.owl
	robot merge \
	  --input $@ \
	  --input $(envo_location)/src/envo/modules/temporary_robot_template.owl \
	  --collapse-import-closure false \
	  convert \
	  --format ofn \
	  --output $@

