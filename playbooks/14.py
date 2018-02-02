#!/usr/bin/python 

import nltk   
import urllib
from stripogram import html2text

url = "https://downloads.chef.io/chef-server/stable"  
html = urlopen(url).read()  
text = html2text(html)
print text