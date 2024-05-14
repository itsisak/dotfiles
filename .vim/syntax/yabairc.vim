" Syntax highlight for yabairc

let s:sonokai_configuration         = sonokai#get_configuration()
let s:palette                       = sonokai#get_palette(
                                        \ s:sonokai_configuration.style,
                                        \ s:sonokai_configuration.colors_override
                                        \ )

let s:commands                      = s:palette.red[0]
let s:options                       = s:palette.purple[0]
let s:string                        = s:palette.yellow[0]
let s:comment                       = s:palette.grey[0]

exe 'highlight Commands     guifg=' . s:commands
exe 'highlight Options      guifg=' . s:options
exe 'highlight String       guifg=' . s:string
exe 'highlight Comment      guifg=' . s:comment

syntax match Commands /\v<\cYABAI|SUDO>/
syntax match Options /\v<\c(
        \WINDOW|
        \NORMAL|
        \ACTIVE|
        \FOCUS|
        \MOUSE|
        \TOP|BOTTOM|LEFT|RIGHT)
        \_[A-Z0-9_]*/
syntax match String /\v".*"|'.*'/
syntax match Comment /\v#.*/

