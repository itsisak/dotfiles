" Syntax highlight for skhdrc

let s:sonokai_configuration         = sonokai#get_configuration()
let s:palette                       = sonokai#get_palette(
                                        \ s:sonokai_configuration.style,
                                        \ s:sonokai_configuration.colors_override
                                        \ )

let s:commands                      = s:palette.red[0]
let s:keys                          = s:palette.blue[0]
let s:string                        = s:palette.yellow[0]
let s:comment                       = s:palette.grey[0]

exe 'highlight Keys         guifg=' . s:keys
exe 'highlight Commands     guifg=' . s:commands
exe 'highlight String       guifg=' . s:string
exe 'highlight Comment      guifg=' . s:comment

syntax match Commands /\v
        \<(\c
            \YABAI|
            \XARGS|
            \JQ|
            \ECHO)
        \>/
syntax match Keys /\v
        \\s+\w\s+|
        \<(\c
            \TAB|
            \ALT|LALT|RALT|
            \CMD|LCMD|RCMD|
            \SHIFT|LSHIFT|RSHIFT|
        \ )>/
syntax match String /\v".*"|'.*'/
syntax match Comment /\v#.*/

