let s:save_cpo = &cpo
set cpo&vim
if exists('g:loaded_colorschemes_settings')
  finish
endif
if !has('patch-8.1.1575')
  finish
endif


command! ColorSchemeSelect call colorschemes_settings#selectColorscheme()


let g:loaded_colorschemes_settings = 1
let &cpo = s:save_cpo
unlet s:save_cpo
