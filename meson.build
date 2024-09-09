project('connerieavous', ['c', 'vala'],
  version : '0.1',
  default_options : ['warning_level=3'])

executable('connerieavous',
           'main.vala',
           dependencies : [
              dependency('gtk4')],
           c_args: '-w',
           vala_args: '--debug',
           install : true)
