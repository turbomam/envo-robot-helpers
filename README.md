# envo-robot-helpers

TODO:
- get last used ID in NMDC's range
    - data @ https://raw.githubusercontent.com/EnvironmentOntology/envo/master/src/envo/envo-idranges.owl OR `../envo/src/envo/envo-idranges.owl`
    - will require a SPARQL engine
        - ROBOT? 
        - ARQ? I have it thanks to X being required by semantic sql
- download Google Sheet to filesystem

```
Datatype: idrange:25

    Annotations:
        allocatedto: "National Microbiome Data Collaborative"

    EquivalentTo:
        xsd:integer[>= 3600000 , <= 3609999]
```

---

```
robot query --input-iri https://raw.githubusercontent.com/EnvironmentOntology/envo/master/src/envo/envo-idranges.owl --query our_last_id.rq our_last_id.tsv
```

---

```
% arq -h

arq --data=<file> --query=<query>
  Control
      --explain              Explain and log query execution
      --repeat=N or N,M      Do N times or N warmup and then M times (use for timing to overcome start up costs of Java)
      --optimize=            Turn the query optimizer on or off (default: on)
  Time
      --time                 Time the operation
  Query Engine
      --engine=EngineName    Register another engine factory[ref]
      --unengine=EngineName   Unregister an engine factory
  Dataset
      --data=FILE            Data for the dataset - triple or quad formats
      --graph=FILE           Graph for default graph of the datset
      --namedGraph=FILE      Add a graph into the dataset as a named graph
  Results
      --results=             Results format (Result set: text, XML, JSON, CSV, TSV; Graph: RDF serialization)
      --desc=                Assembler description file
  Query
      --query, --file        File containing a query
      --syntax, --in         Syntax of the query
      --base                 Base URI for the query
  Symbol definition
      --set                  Set a configuration symbol to a value
  General
      -v   --verbose         Verbose
      -q   --quiet           Run with minimal output
      --debug                Output information for debugging
      --help
      --version              Version information
      --strict               Operate in strict SPARQL mode (no extensions of any kind)
```

---

```
% arq --data=../envo/src/envo/envo-idranges.owl --file our_last_id.rq 
10:13:15 ERROR riot            :: [line: 1, col: 1 ] Content is not allowed in prolog.
Failed to load data
```

Maybe ARQ doesn't like this ? RDF format. Use ROBOT.

```
% robot query -h
usage: robot query --input <file> --query <query> <output>
    --add-prefix <arg>          add prefix 'foo: http://bar' to the output
    --add-prefixes <arg>        add JSON-LD prefixes to the output
 -C,--create-tdb <arg>          if true, create a TDB directory without
                                querying
 -c,--construct <arg>           run a SPARQL CONSTRUCT query (deprecated)
    --catalog <arg>             use catalog from provided file
 -d,--tdb-directory <arg>       directory to put TDB mappings (default:
                                .tdb)
 -f,--format <arg>              the query result format: CSV, TSV, TTL,
                                JSONLD, etc.
 -g,--use-graphs <arg>          if true, load imports as named graphs
 -h,--help                      print usage information
 -I,--input-iri <arg>           load ontology from an IRI
 -i,--input <arg>               load ontology from a file
 -k,--keep-tdb-mappings <arg>   if true, do not remove the TDB directory
 -noprefixes                    do not use default prefixes
 -O,--output-dir <arg>          Directory for output
 -o,--output <arg>              save updated ontology to a file
 -P,--prefixes <arg>            use prefixes from JSON-LD file
 -p,--prefix <arg>              add a prefix 'foo: http://bar'
 -Q,--queries <arg>             verify one or more SPARQL queries
 -q,--query <arg>               run a SPARQL query
 -s,--select <arg>              run a SPARQL SELECT query (deprecated)
    --strict                    use strict parsing when loading an
                                ontology
 -t,--tdb <arg>                 if true, load RDF/XML or TTL onto disk
 -u,--update <arg>              run a SPARQL UPDATE
 -V,--version                   print version information
 -v,--verbose                   increased logging
 -vv,--very-verbose             high logging
 -vvv,--very-very-verbose       maximum logging, including stack traces
 -x,--xml-entities              use entity substitution with ontology XML
                                output
```
