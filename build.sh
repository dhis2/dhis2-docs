#!/bin/bash

if [ ! -d "venv" ]; then
    source venv_setup
fi

source ./venv/bin/activate
src="$PWD/src/commonmark/en"
tmp="$PWD/tmp/en"
target="$PWD/target/commonmark/en"
localisation_root="$PWD/target/commonmark"

rm -rf $tmp
mkdir -p $tmp
rm -rf $target
mkdir -p $target

shared_resources() {
    mkdir -p $1/resources/
    cp -r $src/resources/* $1/resources/
}


assemble_content() {
    echo "assembling $1"
    md=`basename $1 | sed 's:_INDEX\.:\.:'`
    markdown-pp $1 -o $tmp/$md
}

assemble_resources() {
    new=`echo $1 | sed 's/\(.*\)\/resources\/images\(.*\)/resources\/images\/\1\2/'`
    newfull=$2/$new
    mkdir -p `dirname $newfull`
    cp $1 $newfull
}

make_html() {
    name=$1
    subdir=$2
    mkdir -p ${target}/${subdir}/html
    shared_resources ${target}/${subdir}/html
    for res in `grep '(resources/images' ${name}.md | sed 's/.*resources\/images\/\([^)]*\)).*/resources\/images\/\1/'`; do
        mkdir -p ${target}/${subdir}/html/`dirname $res`
        cp $res ${target}/${subdir}/html/$res
    done
    echo "compiling $name.md to html"
    chapters="bookinfo.md ${name}.md"
    pandoc $chapters -c ./resources/css/dhis2.css --template="dhis2_template.html" --toc -N --section-divs -t html5 -o ${target}/${subdir}/html/${name}_full.html

    cd ${target}/${subdir}/html/
    # fix the section mappings in the full html file
    echo "remapping the section identifiers"
    id_mapper ${name}_full.html
    # split the full html file into chunks
    echo "splitting the html file into chunks"
    chunker ${name}_full.html $tmp/dhis2_chunked_template.html
    cd $tmp

}

make_pdf() {
    name=$1
    subdir=$2
    mkdir -p ${target}/${subdir}
    echo "compiling $name.md to pdf"
    chapters="bookinfo.md ${name}.md"
    pandoc $chapters -c ./resources/css/dhis2_pdf.css --template="dhis2_template.html" --toc -N --section-divs --pdf-engine=weasyprint -o ${target}/${subdir}/${name}.pdf
}

generate(){
    name=$1
    subdir=$2
    selection=$3
    if [ ! $selection ]
    then
      selection="both"
    fi

    echo "+--------------------------------------------------------"
    echo "| Processing: $name"
    echo "+--------------------------------------------------------"

    # copy resources and assembled markdown files to temp directory
    shared_resources $tmp
    #cp $src/${name}*.md $tmp/
    cp $src/*template.html $tmp/
    cp $src/content/common/* $tmp/
    cd $src

    # copy resources and assembled markdown files to temp directory
    for f in ${name}_INDEX.md; do
        #echo "file: $f"
        assemble_content $f
    done

    for path in `grep "INCLUDE" ${name}_INDEX.md | sed 's/[^"]*"//' | sed 's/[^/]*"//' | sort -u`; do
      for r in `find $path -type f | grep "resources/images"`; do
          # echo "resource: $r"
          assemble_resources $r $tmp
      done
    done

    # go to the temp directory and build the documents - put output in target directory
    cd $tmp

    gitbranch=`git rev-parse --abbrev-ref HEAD`
    githash=`git rev-parse --short HEAD`
    gitdate=`git show -s --format=%ci $githash`
    gityear=`date -d "${gitdate}" +%Y`
    sed -i "s/<git-branch>/$gitbranch/" bookinfo*.md
    sed -i "s/<git-hash>/$githash/" bookinfo*.md
    sed -i "s/<git-date>/$gitdate/" bookinfo*.md
    sed -i "s/<git-year>/$gityear/" bookinfo*.md

    if [ $selection == "html" ]
    then
      make_html $name $subdir
    elif [ $selection == "pdf" ]
    then
      make_pdf $name $subdir
    else
      make_html $name $subdir
      make_pdf $name $subdir
    fi

}

# for r in `find . -type f | grep "resources/images"`; do
#     #echo "resource: $r"
#     assemble_resources $r $tmp
# done


# comment as you wish
# format:
# $> generate <doc name> <chapters subfolder> ["html","pdf","both"]
generate "dhis2_android_user_man" "android"
generate "dhis2_developer_manual" "developer"
generate "dhis2_user_manual_en" "user"
generate "dhis2_end_user_manual" "end-user"
generate "dhis2_implementation_guide" "implementer"
generate "user_stories_book" "user-stories"
generate "dhis2_draft_chapters" "draft"

rm -rf $tmp
