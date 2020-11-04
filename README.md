# Vim Colorscheme Settings 🎨
Colorscheme switcher for Vim

## Function
- Change colorschemes *interactive*.

## How To Use

```:SwitchColorscheme```  
```:SwitchBackGround```  
Like VS Code, you can change Vim's Colorscheme .  
You can select the Color scheme using J or K or the cursor keys.  
You can then confirm your selection with the Enter or Spacebar.  


## Options
```g:colorschemes_settings#use_default_colorschemes```  
Setting this flag to v: false will prevent the standard color scheme from being loaded


```g:colorschemes_settings#rc_file_path```
Specifies where the settings are saved when the colorscheme is changed  
This path is not automatically expanded  
Note that the file will be overwritten
  
Example
  ```let g:colorscheme_settings#colorrc_path = expand('~/.vim/colorrc.vim')```  
If you want to set option when Vim starts. write this code to your .vimrc  
```
let s:colorrcpath = expand('~/.vim/colorrc.vim')
if filereadable(s:colorrcpath)
  execute "source" s:colorrcpath
endif
```


## ScreenShot
![screen](https://github.com/kato-k/assets/blob/master/render1603724148552.gif)  

## Note
My English is broken.  
If you find any mistakes in the readme or document, please let me know.  

## License

MIT  

## Author
Kota Kato a.k.a kato-k  
