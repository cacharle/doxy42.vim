" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    doxy42.vim                                         :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: cacharle <me@cacharle.xyz>                 +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2020/10/05 10:44:46 by cacharle          #+#    #+#              "
"    Updated: 2021/02/25 16:37:23 by cacharle         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

function! s:Doxy42()
    normal! mq

    let l:line = getline('.')

    let l:match_pos = match(l:line, '(')
    if l:match_pos == -1
        echo 'Use this command on function declaration line'
        return
    endif

    call cursor(line('.'), l:match_pos + 1)
    normal! yi(
    normal! `q

    let l:args = substitute(@", "\n", ' ', 'g')
    let l:args = split(l:args, ',')

    let l:has_return = match(l:line[:match_pos], 'void') == -1
    if !l:has_return && match(l:line[:match_pos], 'void\s*\*') != -1
        let l:has_return = 1
    endif

    let l:i = 0
    while i < len(l:args)
        let l:args[i] = substitute(l:args[i], '\[.*\]', '', 'g')
        let l:args[i] = substitute(l:args[i], '(\*\([a-z]*\))(.*)', '\1', '')
        let l:args[i] = get(split(l:args[i]), -1)
        while l:args[i][0] ==# '*'
            let l:args[i] = l:args[i][1:]
        endwhile
        let i = i + 1
    endwhile

    let l:max_arg_width = 0
    for a in l:args
        if len(a) > l:max_arg_width
            let l:max_arg_width = len(a)
        endif
    endfor
    let l:max_arg_width += 2

    let l:comment_lines = ['/*', '** \brief '. repeat(' ', l:max_arg_width)]
    for a in l:args
        let l:comment_lines += ['** \param ' . a . repeat(' ', l:max_arg_width - strlen(a))]
    endfor
    if l:has_return
        let l:comment_lines += ['** \return ' . repeat(' ', l:max_arg_width - 1)]
    endif
    let l:comment_lines += ['*/', '']

    let l:comment_location = line('.') - 1
    call append(l:comment_location, l:comment_lines)
    call cursor(l:comment_location + 2, 0)

    let @/ = '$'
endfunction

augroup doxy42
    autocmd!
    autocmd Filetype c,cpp command! Doxy42 call s:Doxy42()
augroup END
