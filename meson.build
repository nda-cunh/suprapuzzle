project('suprapuzzle', ['c', 'vala'], version : '1.0', default_options : ['warning_level=0', 'optimization=3'])

vala_src = [
  files('main.vala'),
  files('Puzzle.vala'),
  files('Tiles.vala'),
]

executable('suprapuzzle',
  vala_src,
  dependencies : [
    dependency('gtk4')],
  c_args: '-w',
  vala_args: '--debug',
  install : true)
