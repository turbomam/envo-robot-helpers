.PHONY nmdc_envo_id_range.tsv:
	robot query --input-iri https://raw.githubusercontent.com/EnvironmentOntology/envo/master/src/envo/envo-idranges.owl --query nmdc_envo_id_range.rq nmdc_envo_id_range.tsv
