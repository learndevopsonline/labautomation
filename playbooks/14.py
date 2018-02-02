#!/usr/bin/python 

import nltk   
from urllib import urlopen

url = "https://downloads.chef.io/chef-server/stable"    
from stripogram import html2text
text = html2text(url)
print text