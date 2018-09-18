#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 13 15:56:39 2018

@author: philld
"""
import argparse
from bs4 import BeautifulSoup, NavigableString, Comment


def map_ids(soup):
    '''
    Recursively updated the section ids based on the DHIS2-SECTION-ID comments.
    Start at the bottom of the tree and work up to the parents.
    '''

    for s in soup.find_all('section'):
        # start of a new section
        # we want to recursively map any child sections first
        map_ids(s)

        for c in s.find_all(text=lambda text:isinstance(text, Comment)):
            c_parts = c.split(':')
            if c_parts[0] == "DHIS2-SECTION-ID":
                s['id'] = c_parts[1]
                # remove the comment so it isn't used by the parent
                c.extract()
                break

def main():
    # setup command line arguments
    parser = argparse.ArgumentParser(description='Postprocessor for generating'
                                     ' chunked html files.')

    parser.add_argument('FILENAME', help='Input file name (or directory if '
                        'watching)')


    args = parser.parse_args()

    html_doc = args.FILENAME

    with open(html_doc) as fp:
        soup = BeautifulSoup(fp,"html5lib")

    # perform the id mapping
    map_ids(soup)

    # overwrite the original file
    chw = open(html_doc,'w')
    chw.write(soup.prettify())
    chw.close()


if __name__ == "__main__":
    main()