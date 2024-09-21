project('suprapuzzle', ['c', 'vala'], version : '1.0',
  default_options : ['warning_level=0', 'optimization=3', 'buildtype=release'],)


############################################
# Gresources and blueprints 
############################################

gnome = import('gnome')

asresources = gnome.compile_resources(
    'as-resources', 'gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

############################################
# Configuration 
############################################
conf_data = configuration_data()
conf_data.set('password', get_option('password'))

############################################
# Create the executable (suprapuzzle)
############################################
subdir('src')




# useless for now

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
