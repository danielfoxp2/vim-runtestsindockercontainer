if exists('g:runtestsindockercontainer')
    finish
endif
let g:runtestsindockercontainer = 1

function! MapCRtoRunTests()
    nnoremap <cr> :call RunTestFile()<cr>
endfunction
call MapCRtoRunTests()
nnoremap <leader>a :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif
    call RunTestsForMarkedFile(command_suffix)
endfunction

function! RunTestsForMarkedFile(command_suffix)
    let in_test_file = match(expand("%"), '\(_context.exs\|.feature\|_test.exs\|_spec.exs\)$') != -1
    if in_test_file
        call MarkFileAsCurrentTest(a:command_suffix)
    elseif !exists("t:dm_test_file")
        return
    endif
    call RunTests(t:dm_test_file)
endfunction

function! MarkFileAsCurrentTest(command_suffix)
    let t:dm_test_file = expand("%:p") . a:command_suffix
endfunction

function! RunTests(filename)
    let g:docker_command = ':!docker exec -it elixir bash -c '
    
    SaveFileBeforeContinue()

    if match(a:filename, '\(_context.exs\|.feature\)$') != -1
        let mixPathToRunTests = matchstr(expand("%:p"), '\(.*\)\/apps\/.\{-}\/')
        exec g:docker_command . "\"cd " . mixPathToRunTests . " && mix white_bread.run " . a:filename . "\""
    elseif match(a:filename, '_test.exs')
        let mixPathToRunTests = matchstr(expand("%:p"), '\(.*\)\/apps\/.\{-}\/')
        exec g:docker_command . "\"cd " . mixPathToRunTests . " && elixir " . a:filename . "\""
    else
        let mixPathToRunTests = matchstr(expand("%:p"), '\(.*\)\/work\/.\{-}\/')
        exec g:docker_command . "\"cd " . mixPathToRunTests . " && mix espec " . a:filename . "\""
    endif
endfunction

function! SaveFileBeforeContinue()
    if expand("%") != ""
        :w
    endif
endfunction

