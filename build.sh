#!/bin/bash

# we use the build resources from the master branch (commented out for master itself)
git checkout master -- src/commonmark/en/resources
git checkout master -- tools
git checkout master -- lib
git checkout master -- venv_setup
git checkout master -- requirements.txt

# perform all actions relative to the path of this script
SCRIPT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPT_DIR" ]]; then
  SCRIPT_DIR="$PWD"
else
  cd $SCRIPT_DIR
  SCRIPT_DIR="$PWD"
fi

# include helper functions
. "$SCRIPT_DIR/lib/doc_functions.sh"


# comment as you wish
# format:
#$> generate <doc name> <chapters subfolder> ["html","pdf","both"]

echo "    - Implementer:" >> $myml
generate "dhis2_tracker_implementation_guide" "implementer"

echo "    - Packages:" >> $myml
generate "dhis2_covid19_surveillance" "packages"

make_mkdocs


rm -rf $tmp
