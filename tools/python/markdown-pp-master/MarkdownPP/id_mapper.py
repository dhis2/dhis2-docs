#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 13 15:56:39 2018

@author: philld
"""
import argparse
from bs4 import BeautifulSoup, NavigableString, Comment


def main():
    # setup command line arguments
    parser = argparse.ArgumentParser(description='Postprocessor for generating'
                                     ' chunked html files.')

    parser.add_argument('FILENAME', help='Input file name (or directory if '
                        'watching)')


    args = parser.parse_args()

    html_doc = args.FILENAME


    #contents = []
    #chunks = []


    with open(html_doc) as fp:
        soup = BeautifulSoup(fp,"html5lib")

    for s in soup.find_all('section'):
        # start of a new section
        for c in s.find_all(text=lambda text:isinstance(text, Comment)):
            c_parts = c.split(':')
            if c_parts[0] == "DHIS2-SECTION-ID":
                s['id'] = c_parts[1]
                break

        

    chw = open(html_doc,'w')
    chw.write(soup.prettify())
    chw.close()


if __name__ == "__main__":
    main()