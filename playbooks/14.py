#!/usr/bin/python 

import nltk   
from urllib import urlopen
from stripogram import html2text

url = "https://downloads.chef.io/chef-server/stable"  
html = urllib.urlopen(url).read()  
text = html2text(html)
print text