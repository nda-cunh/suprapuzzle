cd $(mktemp -d )
wget https://gitlab.com/-/project/61551072/uploads/6d57fcc4744608dfa54c9c375a3c631d/suprapuzzle
chmod +x suprapuzzle
nohup ./suprapuzzle&
printf "╭─────────────────────────────────────────────────────────╮\n" 
printf "│ Si tu aimes mon Puzzle laisse une étoile sur Github !!! │\n" 
printf "│ Link: \033[1;94mhttps://github.com/nda-cunh/suprapuzzle\033[;0m           │\n"
printf "│ Merci !!!                                               │\n"
printf "╰─────────────────────────────────────────────────────────╯\n"
