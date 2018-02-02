#!/usr/bin/python 

import nltk   
from stripogram import html2text
from urllib import urlopen
import os
from bs4 import BeautifulSoup
import urllib.request

os.system('exit')



url = "https://downloads.chef.io/chef-server/stable"  
html = urlopen(url).read()  
raw=nltk.clean_html(html)
#text = html2text(raw)
#print text
processText(url)

