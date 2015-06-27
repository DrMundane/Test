format PE GUI 4.0
entry start

include '%fasminc%\win32a.inc'

section '.data' data readable writeable
	wHMain	dd ?
	wHInstance     dd ?

	wTitle db 'Window Title',0 ;window title
	wClsName  db 'WINDOWS_BITCHES!',0

	wMsg MSG
	wCls WNDCLASS

	expBoxTitle	db 'Menu Action Description',0
	expBoxDesc11	db 'MenuBar A - Item 1',0
	expBoxDesc12	db 'Bar A - Item 2',0
	expBoxDesc13	db 'Bar a - Item 3',0
	expBoxDesc21	db 'Bar B - Item 1',0
	expBoxDesc30	db 'Bar C',0

section '.code' code readable executable
start:
	    invoke GetModuleHandle,NULL  ;window class lets go!
		mov [wHInstance],eax
		mov [wCls.hInstance],eax
		mov [wCls.style], CS_HREDRAW or CS_VREDRAW
		mov [wCls.lpfnWndProc],window_procedure
		mov [wCls.lpszClassName],wClsName
		mov [wCls.hbrBackground],COLOR_WINDOW+1
	    invoke LoadIcon,NULL,IDI_APPLICATION
		mov [wCls.hIcon],eax
	    invoke LoadCursor,NULL,IDC_ARROW
		mov [wCls.hCursor],eax
	    invoke RegisterClass,wCls
	    invoke    LoadMenu,[wHInstance],30

	    ;CREATING THE WINDOW
	    invoke CreateWindowEx,\
	    0,\
	    wClsName,\
	    wTitle,\
	    WS_OVERLAPPEDWINDOW,\
	    CW_USEDEFAULT,\
	    CW_USEDEFAULT,\
	    CW_USEDEFAULT,\
	    CW_USEDEFAULT,\
	    NULL,\
	    eax,\
	    [wHInstance],\
	    NULL
		mov [wHMain],eax
		invoke	  ShowWindow,[wHMain],SW_SHOW
 ;message looop
	window_message_loop_start:
		invoke	GetMessage,wMsg,NULL,0,0
			or eax,eax
			je window_message_loop_end
		invoke	TranslateMessage,wMsg
		invoke	DispatchMessage,wMsg
			jmp	window_message_loop_start

	window_message_loop_end:
		invoke	ExitProcess,0 ;Really the most important part...
;Window Procedure
	proc	window_procedure,hWnd,uMsg,wParam,lParam
		push ebx esi edi    ;The Register Condom
		cmp [uMsg],WM_COMMAND
		je wmCOMMAND
		cmp [uMsg],WM_DESTROY
		je wmDESTROY

		wmDEFAULT:
			invoke DefWindowProc,[hWnd],[uMsg],[wParam],[lParam]
			jmp wmBYE
		wmCOMMAND:
			mov eax,[wParam]
			cmp ax,11
			je wmCOMMAND_11
			cmp ax,12
			je wmCOMMAND_12
			cmp ax,13
			je wmCOMMAND_13
			cmp ax,21
			je wmCOMMAND_21
			cmp ax,30
			je wmCOMMAND_30
			jmp wmDEFAULT
		    wmCOMMAND_11:
			      invoke	MessageBox,[hWnd],expBoxDesc11,expBoxTitle,MB_OK
			      jmp  wmBYE
		    wmCOMMAND_12:
			      invoke	MessageBox,[hWnd],expBoxDesc12,expBoxTitle,MB_OK
			      jmp  wmBYE
		    wmCOMMAND_13:
			      invoke	MessageBox,[hWnd],expBoxDesc13,expBoxTitle,MB_OK
			      jmp  wmBYE
		    wmCOMMAND_21:
			      invoke	MessageBox,[hWnd],expBoxDesc21,expBoxTitle,MB_OK
			      jmp  wmBYE
		    wmCOMMAND_30:
			      invoke	MessageBox,[hWnd],expBoxDesc30,expBoxTitle,MB_OK
			      jmp  wmBYE
	       wmDESTROY:
		    invoke    PostQuitMessage,0

	       wmBYE:
		    pop  edi esi ebx
		    ret
	  endp

section '.idata' import data readable writeable
     library   KERNEL32, 'KERNEL32.DLL',\
	       USER32,	 'USER32.DLL'

     import    KERNEL32,\
	       GetModuleHandle,    'GetModuleHandleA',\
	       ExitProcess,	   'ExitProcess'

     import    USER32,\
	       RegisterClass,	   'RegisterClassA',\
	       CreateWindowEx,	   'CreateWindowExA',\
	       DefWindowProc,	   'DefWindowProcA',\
	       ShowWindow,	   'ShowWindow',\
	       LoadCursor,	   'LoadCursorA',\
	       LoadIcon,	   'LoadIconA',\
	       LoadMenu,	   'LoadMenuA',\
	       GetMessage,	   'GetMessageA',\
	       MessageBox,	   'MessageBoxA',\
	       TranslateMessage,   'TranslateMessage',\
	       DispatchMessage,    'DispatchMessageA',\
	       PostQuitMessage,    'PostQuitMessage'

section '.rsrc' resource data readable
     directory RT_MENU,appMenu

     resource  appMenu,\
	       30,LANG_ENGLISH,menuMain

     menu menuMain
	  menuitem  'MenuBar A',10,MFR_POPUP
	  menuitem	 'MenuBar A - Item 1',11,MFT_STRING
	  menuitem	 'Bar A - Item 2',12,MFT_STRING
			 menuseparator
	  menuitem	 'Bar a - Item 3',13,MFR_END
	  menuitem  'MenuBar B',20,MFR_POPUP
	  menuitem	 'Bar B - Item 1',21,MFR_END
	  menuitem  'Bar C',30,MFR_END