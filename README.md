for work

$ find Adm/ -name "*.md" | xargs.exe cat | pandoc -f markdown -o Adm.pdf -V documentclass=ltjltxdoc -H preanble.tex --pdf-engine=lualatex --toc -N

$ find Edu/ -name "*.md" | xargs.exe cat | pandoc -f markdown -o Edu.pdf -V documentclass=ltjltxdoc -H preanble.tex --pdf-engine=lualatex --toc -N


