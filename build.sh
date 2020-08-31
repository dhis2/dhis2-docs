#!/bin/bash

# we use the build resources from the master branch (commented out for master itself)
# git checkout master -- src/commonmark/en/resources
# git checkout master -- tools
# git checkout master -- lib
# git checkout master -- venv_setup
# git checkout master -- requirements.txt

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
generate "dhis2_action_tracker_manual" "at-app"
generate "dhis2_bottleneck_analysis_manual" "bna-app"
generate "dhis2_scorecard_manual" "scorecard-app"

echo "    - Implementer:" >> $myml
generate "dhis2_implementation_guide" "implementer"
generate "dhis2_tracker_implementation_guide" "implementer"
generate "dhis2_android_implementation_guideline" "implementer"
generate "dhis2_android_capture_app" "android-app"
generate "dhis2_android_MDM" "mdm"
generate "user_stories_book" "user-stories"

echo "    - Developer:" >> $myml
generate "dhis2_developer_manual" "developer"
generate "dhis2_android_sdk_developer_guide" "android-sdk"

echo "    - Sysadmin:" >> $myml
generate "dhis2_system_administration_guide" "sysadmin"

echo "    - Metadata:" >> $myml
generate "dhis2_who_digital_health_data_toolkit" "metadata"
generate "dhis2_covid19_surveillance" "packages"

make_mkdocs

generate "dhis2_draft_chapters" "draft"

rm -rf $tmp
