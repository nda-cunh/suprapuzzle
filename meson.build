project('suprapuzzle', ['c', 'vala'], version : '2.2',
  default_options : ['warning_level=0', 'optimization=3', 'buildtype=release'],
  meson_version: '>= 1.5.0')

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
#include <sodium.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>


int main ()
{
    if (sodium_init() < 0) {
        return 1;
    }

    uint8_t hash[crypto_pwhash_STRBYTES];
    if (crypto_pwhash_str(hash, "''' + password + '''", strlen("''' + password + '''"), crypto_pwhash_OPSLIMIT_INTERACTIVE, crypto_pwhash_MEMLIMIT_INTERACTIVE) != 0) {
        return 1;
    }
    printf("%s", hash);
	return 0;
}
''',
  dependencies: [dependency('libsodium')],
  name: 'hash',
  required: true,
)
password = result.stdout()
message('Password hash: ' + password)


conf_data.set('password', password)
conf_data.set('version', meson.project_version())

############################################
# Create the executable (suprapuzzle)
############################################

subdir('src')


# Suprapack
if find_program('suprapack', required: false).found()
  description = 'a simple puzzle game if your session is not locked'
  conf_data = configuration_data()

  conf_data.set('name', meson.project_name())
  conf_data.set('version', meson.project_version())
  conf_data.set('description', description)

  info_file = configure_file(input : 'info.in', output : 'info', configuration : conf_data)

  install_data(info_file, install_dir: '.')
  meson.add_install_script('suprapack_build.sh')
endif
