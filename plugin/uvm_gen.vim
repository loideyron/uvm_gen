" Vim UVM Generator Plugin
" Language        :   Vim
" Original Creator:   Hong Jin <hon9jin@gmail.com>
" -----------------------------------------------------
" Forked by Lloyd Yandoc <https://github.com/loideyron>
" * updates for personal / professional use
" For version vim7.x or above

" vimrc: setup reload
if (exists("g:uvm_plugin_loaded") && g:uvm_plugin_loaded)
   finish
endif
let g:uvm_plugin_loaded = 1

" vimrc: setup compatible mode
let s:save_cpo = &cpo
set cpo&vim

" normalize the path
" replace the windows path sep \ with /
function <SID>NormalizePath(path)
    return substitute(a:path, "\\", "/", "g")
endfunction

" Returns a string containing the path of the parent directory of the given
" path. Works like dirname(3). It also simplifies the given path.
function <SID>DirName(path)
    let l:tmp = <SID>NormalizePath(a:path)
    return substitute(l:tmp, "[^/][^/]*/*$", "", "")
endfunction

" Default templates directory
let s:default_template_dir = <SID>DirName(<SID>DirName(expand("<sfile>"))) . "templates"

" Makes a single [variable] expansion, using [value] as replacement.
function <SID>TExpand(variable, value)
    silent execute "%s/{:" . a:variable . ":}/" .  a:value . "/g"
endfunction

" Puts the cursor either at the first line of the file or in the place of
" the template where the %HERE% string is found, removing %HERE% from the
" template.
function <SID>TPutCursor()
    0  " Go to first line before searching
    if search("{:HERE:}", "W")
        let l:column = col(".")
        let l:lineno = line(".")
        silent s/{:HERE:}//
        call cursor(l:lineno, l:column)
    endif
endfunction

" Load the template, and read it
function <SID>TLoadCmd(template)
    if filereadable(a:template)
        " let l:tFile = a:template
        if a:template != ""
            execute "r " . a:template
            setlocal nomodified
        endif
    else
        echo "ERROR! Can not find" . a:template
    endif
endfunction

function! UVM_CheckGlobal (name)
" Look for global variables (if any), to override the defaults.
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function C_CheckGlobal ----------

function! UVMTest(name, ...)
    let template_filename = (a:0 >= 1) ? "uvm_test.svht" : "uvm_test_base.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let base = (a:0 >= 1) ? a:1 : "none"
	
	call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
	if a:0 >= 1
		call <SID>TExpand("BASE", base)
	endif
    call <SID>TPutCursor()
endfunction

function! UVMEnv(name)
    let template_filename = "uvm_env.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TPutCursor()
endfunction

function! UVMAgent(name)
    let template_filename = "uvm_agent.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("TRANSACTION", transaction)
    call <SID>TPutCursor()
endfunction

function! UVMDriver(name)
    let template_filename = "uvm_driver.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("TRANSACTION", transaction)
    call <SID>TPutCursor()
endfunction

function! UVMMon(name)
    let template_filename = "uvm_monitor.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("TRANSACTION", transaction)
    call <SID>TPutCursor()
endfunction

function! UVMSeqr(name)
    let template_filename = "uvm_sequencer.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("TRANSACTION", transaction)
    call <SID>TPutCursor()
endfunction

function! UVMCov(name)
    let template_filename = "uvm_coverage.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("TRANSACTION", transaction)
    call <SID>TPutCursor()
endfunction

function! UVMScbd(name)
    let template_filename = "uvm_scoreboard.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("TRANSACTION", transaction)
    call <SID>TPutCursor()
endfunction

function! UVMSeq(name, ...)
    let template_filename = (a:0 >= 1) ? "uvm_sequence.svht" : "uvm_sequence_base.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    let transaction = a:name . "_item"
    let base = (a:0 >= 1) ? a:1 : "uvm_sequence#(".transaction.")"
    
    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TExpand("BASE", base)
    call <SID>TPutCursor()
endfunction

function! UVMTr(name)
    let template_filename = "uvm_transaction.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TPutCursor()
endfunction
 
function! UVMConfig(name)
    let template_filename = "uvm_config.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TPutCursor()
endfunction

function! UVMInterface(name)
    let template_filename = "uvm_interface.svt"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TPutCursor()
endfunction

function! UVMCommon(name)
    let template_filename = "uvm_common.svht"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)
    
    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TPutCursor()
endfunction

function! UVMPackage(name)
    let template_filename = "uvm_pkg.svt"
    let template = s:default_template_dir . "/" . template_filename
    let uppername = toupper(a:name)

    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", uppername)
    call <SID>TPutCursor()
endfunction

function! UVMEmpty(name)
	let template_filename = "uvm_empty.svht"
	let template = s:default_template_dir . "/" . template_filename
	let uppername = toupper(a:name)

	call <SID>TLoadCmd(template)
	call <SID>TExpand("UPPERNAME", uppername)
	call <SID>TPutCursor()
endfunction


" === plugin commands === {{{

command -nargs=+ UVMTest    call UVMTest(<f-args>)
command -nargs=1 UVMEnv     call UVMEnv("<args>")
command -nargs=1 UVMAgent   call UVMAgent("<args>")
command -nargs=1 UVMDriver  call UVMDriver("<args>")
command -nargs=1 UVMMon     call UVMMon("<args>")
command -nargs=1 UVMCov     call UVMCov("<args>")
command -nargs=1 UVMSeqr    call UVMSeqr("<args>")
command -nargs=1 UVMScbd    call UVMScbd("<args>")
command -nargs=+ UVMSeq     call UVMSeq(<f-args>)
command -nargs=1 UVMItem    call UVMTr("<args>")
command -nargs=1 UVMConfig  call UVMConfig("<args>")
command -nargs=1 UVMIntf    call UVMInterface("<args>")
command -nargs=1 UVMCommon  call UVMCommon("<args>")
command -nargs=1 UVMPkg     call UVMPackage("<args>")
command -nargs=1 UVMEmpty   call UVMEmpty("<args>");
" }}}

" cleanup
let &cpo = s:save_cpo
unlet s:save_cpo
