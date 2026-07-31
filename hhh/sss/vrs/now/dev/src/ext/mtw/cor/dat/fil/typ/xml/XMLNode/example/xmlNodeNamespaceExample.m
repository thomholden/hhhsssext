%Create node using document name
v = XMLNode('outline.xml')

%Basic navigation with namespaces
v('pre1:course')
v('pre1:course/pre1:path_list')
allPaths = v{'pre1:course/pre1:path_list/pre1:dir_name'}

%Use of axes with namespaces
v('//pre1:time')
allTimes = v{'//pre1:time'}

%Adding and then using a custom prefix
addNamespacePrefix(v,'newPrefix','http://www.mathworks.com/training/course_development')
v('newPrefix:course')