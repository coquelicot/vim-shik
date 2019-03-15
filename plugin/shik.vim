let s:shik_message_queue = []
let s:shik_command_handler_map = {}

function! TeachShik(command, handler)
    let s:shik_command_handler_map[a:command] = a:handler
endfunction

function! SendCommandToShik(command, ...)
    let l:delay = get(a:, 1, 0)
    if l:delay == 0
        call add(s:shik_message_queue, a:command)
        call s:GoGoPowerShik()
    elseif
        call timer_start(l:delay, { _ -> SendCommandToShik(a:command) })
    endif
endfunction

function! s:GoGoPowerShik()
    while len(s:shik_message_queue) > 0
        let l:message = remove(s:shik_message_queue, 0)
        let l:command = l:message['command']
        let l:Handler = get(s:shik_command_handler_map, l:command)
        call l:Handler(l:message)
    endwhile
endfunction

for filepath in globpath(expand('<sfile>:p:h:h') . '/commands', '*', 0, 1)
    execute 'source ' . fnameescape(filepath)
endfor
