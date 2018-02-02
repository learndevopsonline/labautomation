#!/usr/bin/python 

import nltk   
from stripogram import html2text
from urllib import urlopen
import os
from bs4 import BeautifulSoup
#import urllib.request


html_doc = """Some HTML code that you want to convert"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html_doc)
print(soup.get_text())



os.system('exit')



url = "https://downloads.chef.io/chef-server/stable"  
html = urlopen(url).read()  
raw=nltk.clean_html(html)
#text = html2text(raw)
#print text
processText(url)

