#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 13 15:56:39 2018

@author: philld
"""
import argparse
import re
import unicodedata
import hashlib

def slugify(value, allow_unicode=False):
    """
    Convert to ASCII if 'allow_unicode' is False. Convert spaces to hyphens.
    Remove characters that aren't alphanumerics, underscores, or hyphens.
    Convert to lowercase. Also strip leading and trailing whitespace.
    """
    value = str(value)
    if allow_unicode:
        value = unicodedata.normalize('NFKC', value)
    else:
        value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore').decode('ascii')
    value = re.sub(r'[^\w\s-]', '', value).strip().lower()
    return re.sub(r'[-\s]+', '-', value)




def main():
    # setup command line arguments
    parser = argparse.ArgumentParser(description='Postprocessor for generating'
                                     ' chunked html files.')

    parser.add_argument('FILENAME', help='Input file name (or directory if '
                        'watching)')

    args = parser.parse_args()

    book = args.FILENAME
    #root=html_doc.split('/')[-1].replace('.md','')

    bmap={}
    content = ""
    with open(book+".md") as ob:
        line = ob.readline()
        chapter=0
        lastchapter=""
        lastname=None
        lastfound=""
        codebloc=False
        while line:
            try:
                if not codebloc:
                    # check if the line matches "# <Title>"
                    # if so, treat as a new chapter
                    found = re.search('^# (.+?)($|<!--.*$)', line.rstrip()).group(1)
                    newname = slugify(found)

                    if lastname:
                        chk = hashlib.md5(lastchapter.encode('utf-8')).hexdigest()
                        lc = open(lastname+".md",'w')
                        lc.write(lastchapter)
                        lc.close
                        try:
                            bmap[newname] += [chk]
                            if newname == "tanzania-integrated-health-information-architecture":
                                newname += "_B"
                        except KeyError:
                            bmap.update({newname:[chk]})

                    lastname = book+"/"+newname
                    lastfound = found
                    lastchapter = line
                    content += '        - '+lastfound+": "+lastname+'.md"\n'

                    print(book,newname)
                    chapter+=1
                    # start a new chapter
            except AttributeError:
                # error message does not match the pattern
                found = '' # apply your error handling

            try:
                if line[:2] == "``":
                    #print(line)
                    if codebloc:
                        codebloc = False
                    else:
                        codebloc = True
            except:
                pass

            if chapter == 0:
                content += line
            elif found == '':
                # continue current chapter
                lastchapter += line

            line = ob.readline()

        if lastname:
            chk = hashlib.md5(lastchapter.encode('utf-8')).hexdigest()
            lc = open(lastname+".md",'w')
            lc.write(lastchapter)
            lc.close

            try:
                bmap[newname] += [chk]
            except KeyError:
                bmap.update({newname:[chk]})
    #ob.close()

# update the Yaml file
    ub = open("mkdocs.yaml",'a')
    ub.write(content)
    ub.close()




if __name__ == "__main__":
    main()
