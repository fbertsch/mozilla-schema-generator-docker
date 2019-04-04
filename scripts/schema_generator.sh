#!/bin/bash

GCS_BUCKET="mozilla-generated-schemas"
GLEAN_SCHEMAS_DIR="glean"
MAIN_SCHEMAS_DIR="main"

rm -rf $GLEAN_SCHEMAS_DIR
rm -rf $MAIN_SCHEMAS_DIR

mozilla-schema-generator generate-glean-ping --out-dir $GLEAN_SCHEMAS_DIR --pretty
mozilla-schema-generator generate-main-ping --out-dir $MAIN_SCHEMAS_DIR --pretty --split

for dir_name in $GLEAN_SCHEMAS_DIR $MAIN_SCHEMAS_DIR; do
    for schema_file in $dir_name/*.schema.json; do
        AVRO_OUT=${schema_file/schema.json/avro}
        BQ_OUT=${schema_file/schema.json/bq}
        jsonschema-transpiler --type avro $schema_file > $AVRO_OUT
        jsonschema-transpiler --type bigquery $schema_file> $BQ_OUT
    done
    gsutil -m cp -r $dir_name/ gs://$GCS_BUCKET/
done
