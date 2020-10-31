let s:save_cpo = &cpo
set cpo&vim
if exists('g:loaded_colorschemes_settings')
  finish
endif
if !has('patch-8.1.1575')
  finish
endif

if !exists('g:colorschemes_settings#use_default_colorschemes')
  let g:colorschemes_settings#use_default_colorschemes = v:true
endif

command! SwitchColor call g:colorschemes_settings#switch_colorscheme(
      \g:colorschemes_settings#use_default_colorschemes,
      \)

let g:loaded_colorschemes_settings = 1
let &cpo = s:save_cpo
unlet s:save_cpo
