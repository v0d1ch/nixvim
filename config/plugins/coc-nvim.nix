{pkgs, inputs, opts, ...}:
{
  extraPlugins = with pkgs.vimPlugins; [ coc-nvim ];
  # nmap <Leader>gr <Plug>(coc-references)
  # nmap <Leader>gi <Plug>(coc-implementation)
  ## here we need to make sure enter works for selecting the suggestion
  extraConfigVim = '' 
    let g:coc_data_home = $HOME . '/.config/coc'
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>d <Plug>(coc-definition)
    nmap <leader>t <Plug>(coc-type-definition)
    nmap <leader>z :CocDiagnostics<CR>
    inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>" 
  ''; 

}
