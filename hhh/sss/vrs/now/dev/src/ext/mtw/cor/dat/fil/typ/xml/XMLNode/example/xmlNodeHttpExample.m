%Create using URL of XML data (note this does NOT work with HTML, but will
%work with XHTML)
v = XMLNode('http://rss.slashdot.org/Slashdot/slashdot')

%Get titles and descriptions
titles = v{'//title'}
descriptions = v{'//description'}