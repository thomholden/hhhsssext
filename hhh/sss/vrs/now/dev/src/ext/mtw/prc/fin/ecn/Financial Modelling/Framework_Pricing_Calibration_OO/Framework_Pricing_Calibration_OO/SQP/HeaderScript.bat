@echo off
if exist Header.txt ( 
	for %%f in (*.m) do (
		type Header.txt >> tmpFile
		type %%f >> tmpFile
		type tmpFile > %%f
		del tmpFile
	)
)
