"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"       ███████╗████████╗ █████╗ ████████╗██╗   ██╗███████╗██╗     ██╗███╗   ██╗███████╗
"       ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║   ██║██╔════╝██║     ██║████╗  ██║██╔════╝
"       ███████╗   ██║   ███████║   ██║   ██║   ██║███████╗██║     ██║██╔██╗ ██║█████╗  
"       ╚════██║   ██║   ██╔══██║   ██║   ██║   ██║╚════██║██║     ██║██║╚██╗██║██╔══╝  
"       ███████║   ██║   ██║  ██║   ██║   ╚██████╔╝███████║███████╗██║██║ ╚████║███████╗
"       ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝
"                                                                                
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Requirements:
"   - sainnhe/sonokai                       (colorscheme plugin)
"   - itchyny/vim-gitbranch                 (plugin)
"   - any nerd-font                         (font with icons)
"

let s:sonokai_configuration                 = sonokai#get_configuration()
let s:palette                               = sonokai#get_palette(
                                                \ s:sonokai_configuration.style, 
                                                \ s:sonokai_configuration.colors_override
                                                \ )
let s:bg_primary                            = s:palette.bg1[0]
let s:bg_secondary                          = s:palette.green[0]
let s:bg_tertiary                           = s:palette.bg3[0]
let s:fg_primary                            = s:palette.fg[0]
let s:fg_secondary                          = s:palette.black[0]
let s:shadow                                = s:palette.grey_dim[0]
let s:flag_modified                         = s:palette.blue[0]
let s:flag_ro                               = s:palette.red[0]

exe 'highlight Primary'                     . ' guibg=' . s:bg_primary      . ' guifg=' . s:fg_primary
exe 'highlight TertiaryToPrimary'           . ' guibg=' . s:shadow          . ' guifg=' . s:bg_tertiary
exe 'highlight Inactive'                    . ' guibg=' . s:bg_tertiary     . ' guifg=' . s:flag_ro
exe 'highlight Shadow'                      . ' guibg=' . s:bg_primary      . ' guifg=' . s:shadow 
exe 'highlight ReadOnly'                    . ' guibg=' . s:bg_primary      . ' guifg=' . s:flag_ro
exe 'highlight Tab'                         . ' guibg=' . s:bg_tertiary     . ' guifg=' . s:fg_primary
exe 'highlight TabActive'                   . ' guibg=' . s:flag_modified   . ' guifg=' . s:bg_tertiary

function! UpdateSecondaryColor()
    exe 'highlight Secondary'               . ' guibg=' . s:bg_secondary    . ' guifg=' . s:bg_tertiary
    exe 'highlight SecondaryToTertiary'     . ' guibg=' . s:bg_tertiary     . ' guifg=' . s:bg_secondary
    exe 'highlight SecondaryToPrimary'      . ' guibg=' . s:shadow          . ' guifg=' . s:bg_secondary
endfunction

function! UpdateModifiedColor()
    exe 'highlight Modified'                . ' guibg=' . s:bg_primary      . ' guifg=' . s:flag_modified
endfunction

let g:right_triangle                        = ""
let g:left_triangle                         = ""
let g:folder                                = "󰉓"
let g:file                                  = "󰧮"
let g:command                               = "󰘳"
let g:clock                                 = ""
let g:git                                   = ""
"let g:lightning                             = "⚡"
let g:lightning                             = "󱐌"
let g:snow                                  = ""
let g:lock                                  = ""
let g:pencil                                = "󰙏"
let g:term                                  = ""
let g:eye                                   = "󰈈"
let g:vim                                   = ""

set laststatus=2

function! Statusline#active()
    let b:branch    = gitbranch#name()
    let b:islarge   = winwidth(0) > 80

    setlocal statusline=%#Secondary#\ %{StatuslineMode()}\ 

    if b:islarge && b:branch != ""
        setlocal statusline+=%#SecondaryToTertiary#%{g:right_triangle}
        setlocal statusline+=\ %{g:git}
        if len(b:branch) > 20
            setlocal statusline+=\ %{b:branch[:20]}..
        else
            setlocal statusline+=\ %{b:branch}
        endif
        setlocal statusline+=\ %#TertiaryToPrimary#%{g:right_triangle}
    else
        setlocal statusline+=%#SecondaryToPrimary#%{g:right_triangle}
    endif

    setlocal statusline+=%#Shadow#%{g:right_triangle}
    setlocal statusline+=%#Primary#

    if b:islarge
        setlocal statusline+=\ %{g:folder}
    endif
    
    if len(expand('%:f')) > 40
        setlocal statusline+=\ %t
    else
        setlocal statusline+=\ %f
    endif

    if b:islarge
        setlocal statusline+=%#Modified#\ %{ModifiedFlag()} 
        setlocal statusline+=%=

        setlocal statusline+=%#Primary#\ %{g:file}\ %{&ft}\ 
        setlocal statusline+=%#Shadow#%{g:left_triangle}%#SecondaryToPrimary#%{g:left_triangle}
        setlocal statusline+=%#Secondary#\ %P\ ~\ %l/%L\ %{g:clock}\ %{strftime(\"%H:%M\")}\ 
    endif
endfunction

function! Statusline#inactive()
    setlocal statusline=%#Inactive#\ %{g:lock}\ INACTIVE\ 
    setlocal statusline+=%#TertiaryToPrimary#%{g:right_triangle}
    setlocal statusline+=%#Shadow#%{g:right_triangle}
    setlocal statusline+=%#Primary#\ %f
endfunction

function! ModifiedFlag()
    if &modified
        let s:flag_modified                 = s:palette.yellow[0]
        let b:modified_icon                 = g:lightning
    else
        let s:flag_modified                 = s:palette.blue[0]
        let b:modified_icon                 = g:snow
    endif  
    call UpdateModifiedColor()
    return b:modified_icon
endfunction

function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        let s:bg_secondary                  = s:palette.green[0]
        let b:mode                          = g:vim     . " NORMAL"
    elseif l:mode==#"i"
        let s:bg_secondary                  = s:palette.purple[0]
        let b:mode                          = g:pencil  . " INSERT"
    elseif l:mode==#"R"
        let s:bg_secondary                  = s:palette.purple[0]
        let b:mode                          = g:pencil  . " REPLACE"
    elseif l:mode==#"c"
        let s:bg_secondary                  = s:palette.orange[0]
        let b:mode                          = g:command . " COMMAND"
    elseif l:mode==#"v"
        let s:bg_secondary                  = s:palette.blue[0]
        let b:mode                          = g:eye     . " VISUAL"
    elseif l:mode==#"V"
        let s:bg_secondary                  = s:palette.blue[0]
        let b:mode                          = g:eye     . " V-LINE"
    elseif l:mode==#"\<C-v>"
        let s:bg_secondary                  = s:palette.blue[0]
        let b:mode                          = g:eye     . " V-BLOCK"
    elseif l:mode==#"s"
        let s:bg_secondary                  = s:palette.blue[0]
        let b:mode                          = g:eye     . " SELECT"
    elseif l:mode==#"t"
        let s:bg_secondary                  = s:palette.orange[0]
        let b:mode                          = g:term    . " TERMINAL"
    elseif l:mode==#"!"
        let s:bg_secondary                  = s:palette.orange[0]
        let b:mode                          = g:term    . " SHELL"
    endif
    if &readonly
        let s:bg_secondary                  = s:palette.red[0]
        let b:mode                          = g:lock    . " READ ONLY"
    endif
    call UpdateSecondaryColor()
    return b:mode
endfunction

augroup statusline
    autocmd!
    autocmd WinEnter,BufEnter * call Statusline#active()
    autocmd WinLeave,BufLeave * call Statusline#inactive()
augroup end

set tabline=%!TabLine()

function! TabLine()
    let s = ""
    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s .= '%#TabActive#'
        else
            let s .= '%#Tab#'
        endif
        let s .= " "
        let s .= i + 1
        let n = ''  
        let m = 0
        let buflist = tabpagebuflist(i + 1)
        for b in buflist
            if getbufvar(b, "&modifiable")
                let n .= fnamemodify(bufname(b), ':t') . ' ~ ' 
            endif
            if getbufvar(b, "&modified")
                let m += 1
            endif
        endfor
        let n = substitute(n, '\~ $', '', '')
        if m > 0
            let s .= " " . g:lightning . " "
        else
            let s .= " " . g:snow . " "
        endif
        if n == ""
            let s .= "[NEW FILE] "
        else
            let s .= n . " "
        endif
    endfor
    let s .= '%#Primary#%T'
    return s
endfunction

