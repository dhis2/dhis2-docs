#!/bin/bash

if [ ! -d "venv" ]; then
    source venv_setup
fi

source ./venv/bin/activate
src="$PWD/src/commonmark/en"
tmp="$PWD/tmp"
target="$PWD/target/commonmark/en"

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
    cm=`basename $1 | sed 's:\.index:\.md:'`
    markdown-pp $1 -o $tmp/$cm
}

assemble_resources() {
    new=`echo $1 | sed 's/\.\(.*\)\/resources\/images\(.*\)/resources\/images\1\2/'`
    newfull=$2/$new
    mkdir -p `dirname $newfull`
    cp $1 $newfull
}

make_html() {
    name=$1
    title=$2
    subdir=$3
    mkdir -p ${target}/${subdir}/html
    shared_resources ${target}/${subdir}/html
    for res in `grep "resources/images" ${name}.md | sed 's/.*resources\/images\/\([^)]*\)).*/resources\/images\/\1/'`; do
        mkdir -p ${target}/${subdir}/html/`dirname $res`
        cp $res ${target}/${subdir}/html/$res
    done
    echo "compiling $name.md ($title) to html"
    chapters="bookinfo.yaml ${name}.md"
    pandoc $chapters -c ./resources/css/dhis2.css --template="dhis2_template.html" --toc -N --section-divs -t html5 -V "title":"$title" -V "pagetitle":"$title" -o ${target}/${subdir}/html/${name}_full.html

    cd ${target}/${subdir}/html/
    # fix the section mappings in the full html file
    echo "remapping the section identifiers"
    id_mapper ${name}_full.html 
    # split the full html file into chunks
    echo "splitting the html file into chunks"
    chunker ${name}_full.html $src/dhis2_chunked_template.html
    cd $tmp 

}

make_pdf() {
    name=$1
    title=$2
    subdir=$3
    mkdir -p ${target}/${subdir}
    echo "compiling $name.md ($title) to pdf"
    chapters="bookinfo.yaml ${name}.md"
    pandoc $chapters -c ./resources/css/dhis2_pdf.css --template="dhis2_template.html" --toc -N --section-divs --pdf-engine=weasyprint -V "title":"$title" -V "pagetitle":"$title"  -o ${target}/${subdir}/${name}.pdf
}

# copy resources and assembled marddown files to temp directory
shared_resources $tmp
cp $src/*.html $tmp/
cp $src/content/common/*.yaml $tmp/
cd $src
for f in *.index; do
    #echo "file: $f"
    assemble_content $f
done
for r in `find . -type f | grep "resources/images"`; do
    #echo "resource: $r"
    assemble_resources $r $tmp
done

# go to the temp directory and build the documents - put output in target directory
cd $tmp

# comment as you wish
make_html "dhis2_android_user_man" "DHIS2 Android guide" "android"
make_html "dhis2_developer_manual" "DHIS2 Developer guide" "developer"
make_html "dhis2_user_manual_en" "DHIS2 User guide" "user"
make_html "dhis2_end_user_manual" "DHIS2 End User guide" "end-user"
make_html "dhis2_implementation_guide" "DHIS2 Implementer guide" "implementer"
make_html "user_stories_book" "DHIS2 User Stories" "user-stories"

make_pdf "dhis2_android_user_man" "DHIS2 Android guide" "android"
make_pdf "dhis2_developer_manual" "DHIS2 Developer guide" "developer"
make_pdf "dhis2_user_manual_en" "DHIS2 User guide" "user"
make_pdf "dhis2_end_user_manual" "DHIS2 End User guide" "end-user"
make_pdf "dhis2_implementation_guide" "DHIS2 Implementer guide" "implementer"
make_pdf "user_stories_book" "DHIS2 User Stories" "user-stories"

rm -rf $tmp