let s:kNormalTimeout = 200
let s:kLongTimeout = 500

function! s:IsSpace(char)
    if a:char == " " || a:char == "\t" || a:char == "\n" || a:char == "\v"
        return 1
    else
        return 0
    endif
endfunction

function! s:TypeText(message)
    let l:text = a:message['text']
    let l:index = get(a:message, 'index', 0)
    if l:index < len(l:text)
        execute 'normal! a' . l:text[l:index]
        let l:message = {'command': 'type', 'text': l:text, 'index': l:index + 1}
        if s:IsSpace(l:text[l:index])
            let l:timeout = s:kLongTimeout
        else
            let l:timeout = s:kNormalTimeout
        end
        call timer_start(l:timeout, { _ -> SendCommandToShik(l:message) })
    endif
endfunction

call TeachShik('type', { message -> s:TypeText(message) })

" Example
let s:kShikGreeting = "Hi " . $USER . ", I'm shik.\nI WILL NOT FIX YOUR COMPUTER >.^"
command! HeyShik call SendCommandToShik({'command': 'type', 'text': s:kShikGreeting})
