
vala_src = [
  files('main.vala'),
  files('Puzzle.vala'),
  files('Tiles.vala'),
  files('Menu.vala'),
  files('TimerClock.vala'),
]

vala_deps = [
  dependency('gtk4'),
]

executable('suprapuzzle',
  vala_src,
  asresources,
  dependencies : vala_deps,
  c_args: '-w',
  vala_args: ['--debug'],
  install : true)
