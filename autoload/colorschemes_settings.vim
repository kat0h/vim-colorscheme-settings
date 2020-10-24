let s:save_cpo = &cpo
set cpo&vim


" ウィンドウを表示
function! colorschemes_settings#selectColorscheme() abort
  " Get Colorschemes
  let s:colors = getcompletion("", "color")
  if !exists("g:colors_name")
    let g:colors_name = "default"
  endif
  call remove(s:colors, match(s:colors, g:colors_name))
  call insert(s:colors, g:colors_name)
  " 選択しているいろを保持
  let col = {
        \ 'id': 0,
        \ 'colors': s:colors,
        \}
  " Init Popup
  let g:popUpWindow = popup_create("", #{
        \padding: [1, 1, 1, 1],
        \line: winheight(winnr()),
        \col: winwidth(winnr()),
        \pos: "botright",
        \minwidth: 15,
        \maxwidth: 15,
        \filter: function('s:selectColorschemeFilter', [col]),
        \cursorline: 1,
        \zindex: 1000,
        \})
  call popup_settext(g:popUpWindow, s:colors)
  augroup colorschemes_setting
    autocmd!
    autocmd VimResized * call colorschemes_settings#vimResized()
  augroup END
endfunction


function! s:PopupClosed() abort
  unlet g:popUpWindow
  augroup colorschemes_setting
    autocmd!
  augroup END
endfunction


" キー入力ごとに色を変更（初めの選択は反映されない(実装してない)）
function! s:selectColorschemeFilter(col, winid, key) abort
  let l:beforeColor = a:col.id
  " キーに応じた処理
  if (a:key is# "j") || (a:key is# "\<down>")
    let a:col.id = min([a:col.id+1, len(a:col.colors)-1])
  elseif (a:key is# "k") || (a:key is# "\<up>")
    let a:col.id = max([a:col.id-1, 0])
  endif
  " 初めのいろのインデックスと同じでないなら変更しない
  if l:beforeColor != a:col.id
    execute "colorscheme ".a:col.colors[a:col.id]
  endif
  return popup_filter_menu(a:winid, a:key)
endfunction


function! colorschemes_settings#vimResized() abort
  call popup_setoptions(g:popUpWindow, #{
        \line: winheight(winnr()),
        \col: winwidth(winnr()),
        \})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
