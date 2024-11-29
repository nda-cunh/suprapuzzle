

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
  dependency('x11'),
  meson.get_compiler('vala').find_library('posix'),
]

vala_args = [
  '--debug',
]

if get_option('is_troll') == true
  vala_args += ['-D', 'IS_BLOCKED']
endif

executable('suprapuzzle',
  vala_src,
  asresources,
  dependencies : vala_deps,
  vala_args: vala_args,
  c_args: ['-w'],
  install : true)
