project('suprapuzzle', ['c', 'vala'], version : '1.0', default_options : ['warning_level=0', 'optimization=3'])

gnome = import('gnome')

asresources = gnome.compile_resources(
    'as-resources', 'gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subproject ('libportal',
  default_options : [
    'optimization=3',
    'docs=false',
    'tests=false',
    'default_library=both',
    'backend-gtk3=disabled',
    'backend-qt5=disabled',
    'backend-qt6=disabled',
])

vala_src = [
  files('main.vala'),
  files('Puzzle.vala'),
  files('Tiles.vala'),
  files('Menu.vala'),
  files('TimerClock.vala'),
]

vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')


executable('suprapuzzle',
  vala_src,
  asresources,
  dependencies : [
    dependency('gtk4'),
    dependency('libpng', static : true),
    ],
  c_args: '-w',
  vala_args: ['--debug'],
  install : true)
