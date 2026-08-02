TARGET = entropy_triangle
VERSION = 2_0

TAROPTIONS = --exclude *.svn*
EXTRAS = \
	html \
	+ternary \
	examplePrincipe.m \
	@cell/coordinates.m \
	@double/cen_mcc.m @double/coordinates.m \
	@double/entropies.m \
	@double/entropy_triangle.m \
	@double/explore_entropies.m \
	@double/information.m @double/perplexities.m @double/perplexities2.m \
	@uint16/entropy_triangle.m @uint16/pmi.m @uint16/coordinates.m \
	@uint32/entropy_triangle.m @uint32/pmi.m \
	compareETs.m PrintTable.m\
	license.txt licenses/*.txt 

#This part of the Makefile should be in your personal texmf tree
#-include ~/texmf/tex_svn/Makefile
#-include ~/src/Makefile#doesn't generate bundles or tgz
#The next one generates tgz bundles for latex, but... What the heck!
-include ~/Library/texmf/tex/latex/Makefile
