#!/bin/bash

# build resources from the master branch
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

echo "    - User:" >> $myml
generate "dhis2_user_manual_en" "user"
generate "dhis2_end_user_manual" "end-user"
generate "dhis2_android_user_man" "android"
generate "dhis2_bottleneck_analysis_manual" "bna-app"
generate "dhis2_scorecard_manual" "scorecard-app"

echo "    - Implementer:" >> $myml
generate "dhis2_implementation_guide" "implementer"
generate "dhis2_android_capture_app" "android-app"
generate "user_stories_book" "user-stories"

echo "    - Developer:" >> $myml
generate "dhis2_developer_manual" "developer"
generate "dhis2_android_sdk_developer_guide" "android-sdk"

make_mkdocs

generate "dhis2_draft_chapters" "draft"

rm -rf $tmp
