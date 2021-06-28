.PHONY: nmdc_envo_id_range.tsv find_last_in_range.tsv

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
