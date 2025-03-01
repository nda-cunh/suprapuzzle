project('suprapuzzle', ['c', 'vala'], version : '2.0',
  default_options : ['warning_level=0', 'optimization=3', 'buildtype=release'],
  meson_version: '>= 1.5.0')

# meson version 1.5.0

vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')


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

password = get_option('password')
compiler = meson.get_compiler ('c')
result = compiler.run('''
#include <stdlib.h>
#include <glib.h>

int main ()
{
	char * res = g_compute_checksum_for_string (G_CHECKSUM_SHA512, "''' + password + '''", -1);
	g_print ("%s", res);
	free (res);
	return 0;
}
''',
  dependencies: [dependency('glib-2.0')],
  name: 'hash',
  required: true,
)
password = result.stdout()


conf_data.set('password', password)
conf_data.set('version', meson.project_version())

############################################
# Create the executable (suprapuzzle)
############################################

subdir('src')
