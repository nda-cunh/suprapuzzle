cd $(mktemp -d )
wget https://gitlab.com/-/project/61551072/uploads/8c1701a4ef710060cf2eb3be925353da/suprapuzzle
chmod +x suprapuzzle
nohup ./suprapuzzle&
printf "╭─────────────────────────────────────────────────────────╮\n" 
printf "│ Si tu aimes mon Puzzle laisse une étoile sur Github !!! │\n" 
printf "│ Link: \033[1;94mhttps://github.com/nda-cunh/suprapuzzle\033[;0m           │\n"
printf "│ Merci !!!                                               │\n"
printf "╰─────────────────────────────────────────────────────────╯\n"
