!#/bin/bash

src="$PWD/src/commonmark/en"
target="$PWD/target/commonmark/en"

mkdir -p $target


assemble_content() {
    echo "assembling $1"
    cm=`basename $1 | sed 's:\.index:\.cm:'`
    markdown-pp $1 -o $target/$cm
}

assemble_resources() {
    new=`echo $1 | sed 's/\.\(.*\)\/resources\/images\(.*\)/\/resources\/images\1\2/'`
    newfull=$target/$new
    mkdir -p `dirname $newfull`
    cp $1 $newfull
}

make_html() {
    name=$1
    title=$2
    chapters="bookinfo.yaml ${name}.cm"
    pandoc $chapters -c dhis2.css --template="dhis2_template.html" --toc -N -s --section-divs -V "title":"$title" -o ${name}.html
}

make_pdf() {
    name=$1
    title=$2
    chapters="bookinfo.yaml ${name}.cm"
    pandoc $chapters -c dhis2_pdf.css --template="dhis2_template.html" --toc -N -s --section-divs --pdf-engine=weasyprint -V "title":"$title" -o ${name}.pdf
}

cd $src
for f in *.index
do
    #echo "file: $f"
    assemble_content $f
done

for r in `find . -type f | grep "resources/images"`
do
    #echo "resource: $r"
    assemble_resources $r
done

cp $src/*.css $target/
cp $src/*.html $target/
cp $src/content/common/*.yaml $target/

cd $target 


# comment as you wish
make_html "dhis2_android_user_man" "DHIS2 Android guide"
make_html "dhis2_developer_manual" "DHIS2 Developer guide"
make_html "dhis2_user_manual_en" "DHIS2 User guide"
make_html "dhis2_end_user_manual" "DHIS2 End User guide"
make_html "dhis2_implementation_guide" "DHIS2 Implementation guide"
make_html "user_stories_book" "DHIS2 User Stories"

make_pdf "dhis2_android_user_man" "DHIS2 Android guide"
make_pdf "dhis2_developer_manual" "DHIS2 Developer guide"
make_pdf "dhis2_user_manual_en" "DHIS2 User guide"
make_pdf "dhis2_end_user_manual" "DHIS2 End User guide"
make_pdf "dhis2_implementation_guide" "DHIS2 Implementation guide"
make_pdf "user_stories_book" "DHIS2 User Stories"
