" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    doxy42.vim                                         :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: cacharle <me@cacharle.xyz>                 +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2020/10/05 10:44:46 by cacharle          #+#    #+#              "
"    Updated: 2020/10/05 19:01:04 by cacharle         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

function! s:Doxy42()

    let l:line = getline(".")

    let l:parent_content = match

    let l:args = split(l:line, ',')
    let l:args_names = map




endfunction

autocmd Filetype c,cpp command! Doxy42 call s:Doxy42()
