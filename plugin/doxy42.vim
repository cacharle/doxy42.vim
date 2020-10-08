" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    doxy42.vim                                         :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: cacharle <me@cacharle.xyz>                 +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2020/10/05 10:44:46 by cacharle          #+#    #+#              "
"    Updated: 2020/10/08 18:16:57 by cacharle         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

function! s:Doxy42()
    let l:line = getline(".")

    let l:match_pos = match(l:line, '(.*)')
    if l:match_pos == -1
        echo 'Use this command on function declaration line'
        return
    endif

    let l:has_return = 1
    if match(l:line[:match_pos], 'void') != -1
        let l:has_return = 0
    endif

    let l:parent_content = l:line[l:match_pos + 1:-2]

    let l:args = split(l:parent_content, ',')

    let l:i = 0
    while i < len(l:args)
        let l:args[i] = get(split(l:args[i]), -1)
        while l:args[i][0] == '*'
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

autocmd Filetype c,cpp command! Doxy42 call s:Doxy42()
