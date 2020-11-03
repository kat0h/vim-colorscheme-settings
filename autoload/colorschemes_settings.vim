let s:save_cpo = &cpo
set cpo&vim


let s:popup_width = 15

" 色設定ウィンドウ
function! s:switch_colorscheme_filter(popup_var, winid, key) abort
  if (a:key is# "j") || (a:key is# "\<down")
    let a:popup_var.color_id = min(
          \[
          \a:popup_var.color_id+1,
          \len(a:popup_var.vim_colorschemes)-1,
          \])
  elseif (a:key is# "k") || (a:key is# "\<up>")
    let a:popup_var.color_id = max([
          \a:popup_var.color_id-1,
          \0,
          \])
  elseif (a:key is# "\<C-m>") || (a:key is# "\<CR>") ||
        \(a:key is# "\<space>")
    let a:popup_var.changed_color = v:true
  elseif (a:key is# "x") || (a:key is#"\<C-[>")
    let a:popup_var.status = v:false
  endif
  if !(a:popup_var.status)
    execute "colorscheme " .. a:popup_var.before_color
  else
    execute "colorscheme " ..
          \a:popup_var.vim_colorschemes[a:popup_var.color_id]
  endif
  return popup_filter_menu(a:winid, a:key)
endfunction

function! s:switch_colorscheme_callback(popup_var, id, idx)
  if !(a:idx ==# -1) && !(a:popup_var.rc_file_path ==# '')
    call s:save_color_settings(a:popup_var.rc_file_path)
  endif
  echo "test"
  execute "augroup colorscheme_settings" .. string(a:id)
    autocmd!
  augroup END
endfunction

function! s:switch_colorscheme(
      \use_default_colorschemes, rc_file_path=''
      \) abort
  let l:colorschemes = s:get_vim_colorschemes(a:use_default_colorschemes)
  let l:popup_var = #{
        \color_id: 0,
        \vim_colorschemes: l:colorschemes,
        \changed_color: v:false,
        \status: v:true,
        \before_color: s:get_colors_name(),
        \rc_file_path: a:rc_file_path
        \}
  let popup_id = popup_create("", #{
        \padding: [1, 1, 1, 1],
        \pos: "botright",
        \cursorline: 1,
        \zindex: 1000,
        \maxwidth: s:popup_width,
        \minwidth: s:popup_width,
        \filter: function("s:switch_colorscheme_filter", [l:popup_var]),
        \callback: function("s:switch_colorscheme_callback", [l:popup_var])
        \})

  call s:popup_set_pos(l:popup_id)
  call popup_settext(l:popup_id, l:popup_var.vim_colorschemes)
  execute "augroup colorscheme_settings" .. string(l:popup_id)
    autocmd!
    autocmd VimResized * call function("popup_set_pos")
  augroup END
endfunction

function! g:colorschemes_settings#switch_colorscheme()
  if (g:colorschemes_settings#rc_file_path == '')
    call s:switch_colorscheme(g:colorschemes_settings#use_default_colorschemes)
  else
    call s:switch_colorscheme(
          \g:colorschemes_settings#use_default_colorschemes,
          \g:colorschemes_settings#rc_file_path)
  endif
endfunction


" 関数
function! s:popup_set_pos(winid) abort
  call popup_setoptions(a:winid, #{
        \line: winheight(winnr()),
        \col: winwidth(winnr()),
        \})
endfunction

function! s:get_vim_colorschemes(use_default_colorschemes) abort
  let l:nowcolor = s:get_colors_name()
  let l:return = getcompletion("", "color")
  if !(a:use_default_colorschemes)
    let l:default_color = [
          \"blue", "darkblue", "default", "delek", "desert", "elflord",
          \"evening", "industry", "koehler", "morning", "murphy", "pablo",
          \"peachpuff", "ron", "shine", "slate", "torte", "zellner"]
    for l:i in range(len(l:default_color))
      let l:j = l:return->index(l:default_color[l:i])
      if (l:j != -1)
        call remove(l:return, l:j)
      endif
    endfor
  endif
  if (match(l:return, l:nowcolor) != -1)
    call remove(l:return, match(l:return, l:nowcolor))
  endif
  call insert(l:return, l:nowcolor)
  return l:return
endfunction

function! s:get_colors_name() abort
  if !exists("g:colors_name")
    let l:nowcolor = "default"
  else
    let l:nowcolor = g:colors_name
  endif
  return l:nowcolor
endfunction

function! s:save_color_settings(rc_file_path) abort
  let l:background =
        \substitute(execute('set background?'), "\n", "", "")->split()[0]
  let l:colorscheme = s:get_colors_name()
  let l:lines = ['set '..l:background,
        \'colorscheme '..l:colorscheme]
  call writefile(l:lines, a:rc_file_path)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
