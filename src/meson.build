

config_vala = configure_file(input : 'config.vala.in',
               output : 'config.vala',
               configuration : conf_data)

vala_src = [
  files('main.vala'),
  files('Puzzle.vala'),
  files('Tiles.vala'),
  files('Menu.vala'),
  files('TimerClock.vala'),
  config_vala,
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
