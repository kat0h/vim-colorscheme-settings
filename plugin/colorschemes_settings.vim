let s:save_cpo = &cpo
set cpo&vim
if exists('g:loaded_colorschemes_settings')
  finish
endif
if !has('patch-8.1.1575')
  finish
endif

command! SwitchColor call colorschemes_settings#selectColorscheme()
command! SwitchBack  call colorschemes_settings#selectBackGround()

" let g:colorscheme_settings#colorrc_path

let g:loaded_colorschemes_settings = 1
let &cpo = s:save_cpo
unlet s:save_cpo
