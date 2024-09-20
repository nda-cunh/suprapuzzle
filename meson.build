project('suprapuzzle', ['c', 'vala'], version : '1.0', default_options : ['warning_level=3', 'optimization=3'])

gnome = import('gnome')

asresources = gnome.compile_resources(
    'as-resources', 'gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subdir('src')

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
