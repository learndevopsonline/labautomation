#!/usr/bin/python 

import nltk   
from stripogram import html2text
from urllib import urlopen

from bs4 import BeautifulSoup
import urllib.request


def processText(webpage):

    # EMPTY LIST TO STORE PROCESSED TEXT
    proc_text = []

    try:
        news_open = urllib.request.urlopen(webpage.group())
        news_soup = BeautifulSoup(news_open, "lxml")
        news_para = news_soup.find_all("p", text = True)

        for item in news_para:
            # SPLIT WORDS, JOIN WORDS TO REMOVE EXTRA SPACES
            para_text = (' ').join((item.text).split())

            # COMBINE LINES/PARAGRAPHS INTO A LIST
            proc_text.append(para_text)

    except urllib.error.HTTPError:
        pass

    return proc_text


url = "https://downloads.chef.io/chef-server/stable"  
html = urlopen(url).read()  
raw=nltk.clean_html(html)
text = html2text(raw)
#print text
processText(url)
