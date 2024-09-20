project('suprapuzzle', ['c', 'vala'], version : '1.0', default_options : ['warning_level=0', 'optimization=3'])

gnome = import('gnome')

asresources = gnome.compile_resources(
    'as-resources', 'gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Module LIBPORTAL for screen capture 
# subproject ('libportal',
  # default_options : [
    # 'optimization=3',
    # 'docs=false',
    # 'tests=false',
    # 'default_library=both',
    # 'backend-gtk3=disabled',
    # 'backend-qt5=disabled',
    # 'backend-qt6=disabled',
# ])

vala_src = [
  files('main.vala'),
  files('Puzzle.vala'),
  files('Tiles.vala'),
  files('Menu.vala'),
  files('TimerClock.vala'),
]

executable('suprapuzzle',
  vala_src,
  asresources,
  dependencies : [
    dependency('gtk4'),
  ],
  c_args: '-w',
  vala_args: ['--debug'],
  install : true)
