" ウィンドウを表示
function! colorschemes_settings#selectColorscheme()
  " Get Colorschemes
  let s:colors = getcompletion("", "color")
  " 選択しているいろを保持
  let col = {
        \ 'id': 0,
        \ 'colors': s:colors,
        \}
  " Init Popup
  let s:popUpWindow = popup_menu("", #{
        \border: [1, 1, 1, 1],
        \maxheight: 10,
        \filter: function('s:selectColorschemeFilter', [col])
        \})
  call popup_settext(s:popUpWindow, s:colors)
endfunction


" キー入力ごとに色を変更（初めの選択は反映されない(実装してない)）
function! s:selectColorschemeFilter(col, winid, key)
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

command! ColorSchemeSelect call colorschemes_settings#selectColorscheme()
