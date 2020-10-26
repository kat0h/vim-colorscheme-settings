let s:save_cpo = &cpo
set cpo&vim


" 設定されている色を返す
function! s:getNowColor() abort
  if !exists("g:colors_name")
    let l:nowColor = "default"
  else
    let l:nowColor = g:colors_name
  endif
  return l:nowColor
endfunction


" Vimに設定されている色を返す
function s:getcolorschemes() abort
  let l:nowColor = s:getNowColor()
  let l:default_color = [
        \"blue", "darkblue", "default", "delek", "desert", "elflord",
        \"evening", "industry", "koehler", "morning", "murphy", "pablo",
        \"peachpuff", "ron", "shine", "slate", "torte", "zellner"]
  let l:ret = getcompletion("", "color")
  if (!g:colorscheme_settings#isShowDefaultColorscheme)
    for l:i in range(len(l:default_color))
      let l:j = l:ret->index(l:default_color[l:i])
      if (l:j != -1)
        call remove(l:ret, l:j)
      endif
    endfor
  endif
  " 設定されている色設定をトップに
  if (match(l:ret, l:nowColor) != -1)
    call remove(l:ret, match(l:ret, l:nowColor))
  endif
  call insert(l:ret, l:nowColor)
  return l:ret
endfunction


" ウィンドウを表示
function! colorschemes_settings#selectColorscheme() abort
  " Get Colorschemes
  let s:colors = s:getcolorschemes()
  " 選択している色を保持
  let col = {
        \ 'id': 0,
        \ 'colors': s:colors,
        \ 'write' : v:false
        \}
  " Init Popup
  let g:popUpWindow = popup_create("", #{
        \padding: [1, 1, 1, 1],
        \line: winheight(winnr()),
        \col: winwidth(winnr()),
        \pos: "botright",
        \minwidth: 15,
        \maxwidth: 15,
        \filter: function('s:SelectColorschemeFilter', [col]),
        \cursorline: 1,
        \zindex: 1000,
        \callback: function('s:PopupClosed', [col]),
        \})
  call popup_settext(g:popUpWindow, s:colors)
  " ウィンドウの端を追従
  augroup colorschemes_setting
    autocmd!
    autocmd VimResized * call colorschemes_settings#vimResized()
  augroup END
endfunction


" Popupが<C-m>で閉じられるときに呼ばれる
function! s:PopupClosed(col, i, j) abort
  unlet g:popUpWindow
  if (a:col.write == v:true)
    call popup_dialog('Save to 《'.g:colorscheme_settings#colorrc_path.'》? y/n', #{
          \ filter: 'popup_filter_yesno',
          \ callback: function('s:EndDialog'),
          \})
  endif
  augroup colorschemes_setting
    autocmd!
  augroup END
endfunction


" キー入力ごとに色を変更
function! s:SelectColorschemeFilter(col, winid, key) abort
  let l:beforeColor = a:col.id
  " キーに応じた処理
  if (a:key is# "j") || (a:key is# "\<down>")
    let a:col.id = min([a:col.id+1, len(a:col.colors)-1])
  elseif (a:key is# "k") || (a:key is# "\<up>")
    let a:col.id = max([a:col.id-1, 0])
  elseif (a:key is# "\<C-m>")
    let a:col.write = v:true
  endif
  " 初めののインデックスと同じでないなら変更しない
  if l:beforeColor != a:col.id
    execute "colorscheme ".a:col.colors[a:col.id]
  endif
  return popup_filter_menu(a:winid, a:key)
endfunction


" ウィンドウがリサイズされた時に追従する
function! colorschemes_settings#vimResized() abort
  call popup_setoptions(g:popUpWindow, #{
        \line: winheight(winnr()),
        \col: winwidth(winnr()),
        \})
endfunction


" background選択ウィンドウを表示
function! colorschemes_settings#selectBackGround() abort
  " 0: dark 1: light
  let bak = #{
        \id: 0,
        \write: 0,
        \}
  " Init Popup
  let g:popUpWindow = popup_create("", #{
        \padding: [1, 1, 1, 1],
        \line: winheight(winnr()),
        \col: winwidth(winnr()),
        \pos: "botright",
        \minwidth: 15,
        \maxwidth: 15,
        \filter: function('s:SelectBackGroundFilter', [bak]),
        \cursorline: 1,
        \zindex: 1000,
        \callback: function('s:selectBackgroundClosed', [bak]),
        \})
  call popup_settext(g:popUpWindow, ["Dark", "Light"])
  " ウィンドウの端を追従
  augroup colorschemes_setting
    autocmd!
    autocmd VimResized * call colorschemes_settings#vimResized()
  augroup END
endfunction


" Popupが<C-m>で閉じられるときに呼ばれる
function! s:selectBackgroundClosed(bak, i, j) abort
  unlet g:popUpWindow
  if (a:bak.write == 1)
    call popup_dialog('Save to 《'.g:colorscheme_settings#colorrc_path.'》? y/n', #{
          \ filter: 'popup_filter_yesno',
          \ callback: function('s:EndDialog'),
          \})
  endif
  augroup colorschemes_setting
    autocmd!
  augroup END
endfunction


" キー入力ごとに色を変更
function! s:SelectBackGroundFilter(bak, winid, key) abort
  let l:beforeBak = a:bak.id
  " キーに応じた処理
  if (a:key is# "j") || (a:key is# "\<down>")
    let a:bak.id = min([a:bak.id+1, 1])
  elseif (a:key is# "k") || (a:key is# "\<up>")
    let a:bak.id = max([a:bak.id-1, 0])
  elseif (a:key is# "\<C-m>")
    let a:bak.write = v:true
  endif
  " 初めののインデックスと同じでないなら変更しない
  if l:beforeBak != a:bak.id
    execute "set background=".["dark", "light"][a:bak.id]
  endif
  return popup_filter_menu(a:winid, a:key)
endfunction


" 設定をファイルに保存（Vimスクリプトとして）
function! s:save_setting(filepath) abort
  let l:background =
        \substitute(execute('set background?'), "\n", "", "")->split()[0]
  let l:colorscheme = s:getNowColor()
  let l:lines = ['set '.l:background,
        \'colorscheme '.l:colorscheme]
  call writefile(l:lines, a:filepath)
endfunction


function! s:EndDialog(id, result) abort
  if a:result
    if exists("g:colorscheme_settings#colorrc_path")
      call s:save_setting(g:colorscheme_settings#colorrc_path)
    endif
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
