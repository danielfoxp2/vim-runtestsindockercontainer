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
    let g:docker_command_elixir = ':!docker exec -it elixir bash -c '
    let g:docker_command_js = ':!docker exec -it node ash -c '
    
    call SaveFileBeforeContinue()
    let mixPathToRunTests = GetRootPathOfTheProject()

    if match(a:filename, '\(_context.exs\|.feature\)$') != -1
        exec g:docker_command_elixir . "\"cd " . mixPathToRunTests . " && mix white_bread.run " . a:filename . "\""
    elseif match(a:filename, '_test.exs') != -1
        exec g:docker_command_elixir . "\"cd " . mixPathToRunTests . " && mix test " . a:filename . "\""
    elseif match(a:filename, '_spec.exs') != -1
        " Acho que era preciso ser diferente das linhas acima, que eram executadas somente no projeto umbrella
        " porque era pra rodar em todos os projetos. Por isso que usava direto o work.
        " Como não estou usando umbrella por enquanto, então o código vai servir pra todos os runners
        " let mixPathToRunTests = matchstr(expand("%:p"), '\(.*\)\/work\/.\{-}\/')
        exec g:docker_command_elixir . "\"cd " . mixPathToRunTests . " && mix espec " . a:filename . "\""
    else
        exec g:docker_command_js . "\"cd " . mixPathToRunTests . " && jasmine " . a:filename . "\"" 
    endif
endfunction

function! SaveFileBeforeContinue()
    if expand("%") != ""
        :w
    endif
endfunction

function! GetRootPathOfTheProject()                                                                                                               
    let umbrella_path = matchstr(expand("%:p"), '\(.*\)\/apps\/.\{-}\/')                                                                          
    let root_work_path = matchstr(expand("%:p"), '\(.*\)\/work\/.\{-}\/')                                                                         
                                                                                                                                                  
    if umbrella_path != ''                                                                                                                        
        return umbrella_path                                                                                                                      
    else                                                                                                                                          
        return root_work_path                                                                                                                     
    endif                                                                                                                                         
endfunction                 

