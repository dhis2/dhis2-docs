#!/bin/bash

#
# Requirements:
#
# ensure language packs are installed. e.g. for French
#> sudo apt-get install language-pack-fr
#

# perform all actions relative to the path of this script
SCRIPT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPT_DIR" ]]; then
  SCRIPT_DIR="$PWD"
else
  cd $SCRIPT_DIR
  SCRIPT_DIR="$PWD"
fi

# pushing docs to localisation platform (transifex) is only done on Jenkins
LOCALISE=0
if [[ `id -un` == "jenkins" ]]; then
  # and only where configured
  if [ -f ~/.transifexrc ]; then LOCALISE=1; fi
fi

# set up the python environment
if [ ! -d "venv" ]; then
    source venv_setup
fi
source ./venv/bin/activate

# script variables
src="$SCRIPT_DIR/src/commonmark/en"
TMPBASE="$SCRIPT_DIR/tmp"
tmp="$TMPBASE/en"
localisation_root="$SCRIPT_DIR/target/commonmark"

# clear the output directories
rm -rf $TMPBASE
mkdir -p $TMPBASE
rm -rf $localisation_root
mkdir -p $localisation_root

# include helper functions
. "$SCRIPT_DIR/lib/doc_functions.sh"

# translate function called for each document
translate(){
    name=$1
    subdir=$2
    selection=$3
    lang=$4
    locale=$5

    if [ ! $selection ]
    then
      selection="both"
    fi

    echo "+--------------------------------------------------------"
    echo "| Processing: $name"
    echo "+--------------------------------------------------------"

    # we need to assemble the source documents to consolidate the resources
    assemble $name

    pull_translations $name
    # build localised versions
    build_docs $name $subdir $selection $lang $locale
}

# build localised versions
if [ ${LOCALISE} -eq 1  ]; then

    # for l in fr,fr_FR pt,pt_PT   # this is where you add new languages
    for l in fr,fr_FR
    do

        lang=${l%,*};
        locale=${l#*,};
        echo "translating: $lang [ $locale ]";

        tmp="$TMPBASE/$lang"
        rm -rf $tmp
        mkdir -p $tmp


        # comment as you wish
        # format:
        #$> translate <doc name> <chapters subfolder> ["html","pdf","both"]
        mkdir $tmp
        cp -a $src/resources/mkdocs/* $tmp/
        myml=$tmp/mkdocs.yml

        echo "    - User:" >> $myml
        translate "dhis2_user_manual_en" "user" "both" $lang $locale
        translate "dhis2_end_user_manual" "end-user" "both" $lang $locale
        translate "dhis2_bottleneck_analysis_manual" "bna-app" "both" $lang $locale
        translate "dhis2_scorecard_manual" "scorecard-app" "both" $lang $locale

        echo "    - Implementer:" >> $myml
        translate "dhis2_implementation_guide" "implementer" "both" $lang $locale
        translate "dhis2_android_capture_app" "android-app" "both" $lang $locale
        translate "user_stories_book" "user-stories" "both" $lang $locale

        echo "    - Developer:" >> $myml
        translate "dhis2_developer_manual" "developer" "both" $lang $locale
        echo "        DHIS2 API Javadocs: https://docs.dhis2.org/<version>/javadoc/" >> $myml
        translate "dhis2_android_sdk_user_guide" "android-sdk" "both" $lang $locale

        echo "    - Sysadmin:" >> $myml
        translate "dhis2_system_administration_guide" "sysadmin" "both" $lang $locale

        pushd $tmp
          pushd docs
            ln -s ../resources .
          popd
          rm -rf resources/mkdocs
          mkdocs build --dirty
        popd

        translate "dhis2_draft_chapters" "draft" "both" $lang $locale

    done
fi

# rm -rf $TMPBASE
