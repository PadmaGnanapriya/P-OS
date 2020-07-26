;*****************start of the kernel code***************

;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/



[org 0x000]
[bits 16]

[SEGMENT .text]
    mov ax, 0x0100			;location where kernel is loaded
    mov ds, ax
    mov es, ax
    
    cli
    mov ss, ax				;stack segment
    mov sp, 0xFFFF			;stack pointer at 64k limit
    sti

    push dx
    push es
    xor ax, ax
    mov es, ax
    cli
    mov word [es:0x21*4], _int0x21	; setup interrupt service
    mov [es:0x21*4+2], cs
    sti
    pop es
    pop dx


	
	call welcome
	
  

	call _shell				; call the shell
    
    int 0x19                ; reboot
;END ************************************************************************


_int0x21:
    _int0x21_ser0x01:       ;service 0x01
    cmp al, 0x01            ;see if service 0x01 wanted
    jne _int0x21_end        ;goto next check (now it is end)
    
	_int0x21_ser0x01_start:
    lodsb                   ; load next character
    or  al, al              ; test for NUL character
    jz  _int0x21_ser0x01_end
    mov ah, 0x0E            ; BIOS teletype
    mov bh, 0x00            ; display page 0
    mov bl, 0x07            ; text attribute
    int 0x10                ; invoke BIOS
    jmp _int0x21_ser0x01_start
    _int0x21_ser0x01_end:
    jmp _int0x21_end

    _int0x21_end:
    iret

_shell:
	_shell_begin:
	;move to next line
	call _display_endl

	;display prompt
	call _display_prompt

	;get user command
	call _get_command
	
	;split command into components
	call _split_cmd

	;check command & perform action

	; empty command
	_cmd_none:		
	mov si, strCmd0
	cmp BYTE [si], 0x00
	jne	_cmd_ver		;next command  >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~
	jmp _cmd_done




	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~
	
	; display version
_cmd_ver:		
	mov si, strCmd0
	mov di, cmdVer
	mov cx, 4
	repe	cmpsb
	jne	_cmd_help		;next command   >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~
	
	call _display_endl
	mov si, strOsName		;display version
	mov al, 0x01
    int 0x21
	call _display_space
	mov si, txtVersion		;display version
	mov al, 0x01
    int 0x21
	call _display_space

	mov si, strMajorVer		
	mov al, 0x01
    int 0x21
	mov si, strMinorVer
	mov al, 0x01
    int 0x21
	jmp _cmd_done




    ;>>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

	;display help
_cmd_help:		
	mov si, strCmd0
	mov di, cmdHelp
	mov cx, 4
	repe	cmpsb
	jne	_cmd_hardwareInfo		;next command  >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

	call _display_endl
	mov si, strHelpMsg0	;print help message
	mov al, 0x01
    int 0x21
	call _display_endl
	mov si, strHelpMsg1
	mov al, 0x01
    int 0x21
	call _display_endl
	mov si, strHelpMsg2
	mov al, 0x01
    int 0x21
	call _display_endl
	mov si, strHelpMsg3
	mov al, 0x01
    int 0x21
    call _display_endl
	mov si, strHelpMsg4
	mov al, 0x01
    int 0x21
	jmp _cmd_done




    ;^^^^^^^^^^^^^^^^^^^^^^^^^^
	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~
	;goto features/hardware_info.asm-> _cmd_hardwareInfo
	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^	




	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

	; Clean Screen
_cmd_clear:		
	mov si, strCmd0
	mov di, cmdCls
	mov cx, 4
	repe	cmpsb
	jne	_cmd_off		;next command  >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

	jmp clean_screen_





	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

    ; Shut down POS
_cmd_off:		
	mov si, strCmd0
	mov di, cmdOff
	mov cx, 4
	repe	cmpsb
	jne	_cmd_unknown		;next command >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

	je _shutdown			;Power off

_shutdown:
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15




	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

_cmd_unknown:
	call _display_endl
	mov si, msgUnknownCmd		;unknown command
	mov al, 0x01
    int 0x21



	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~

_cmd_done:
	jmp _shell_begin



	; >>>>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~
	
_shell_end:
	ret

; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;  go to features/keyboard.asm
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


; ------------------------------------------------------------------
; FEATURES -- Code to pull into the kernel


	%INCLUDE "features/hardware_info.asm" //
	%INCLUDE "features/keyboard.asm"   //Move cmd funtions into here
	%INCLUDE "features/clean_screen.asm"
	%INCLUDE "features/welcome.asm"




[SEGMENT .data]
    strWelcomeMsg   db  "        Welcome to P-OS", 0x00
	strPrompt		db	" User>>> ", 0x00
	cmdMaxLen		db	255			;maximum length of commands
	strOsName		db	" P-OS", 0x00	;OS details
	strMajorVer		db	"3", 0x00
	strMinorVer		db	".0", 0x00
	cmdVer			db	"ver", 0x00		; internal commands
	;cmdReBoot    	db	"boot", 0x00
	cmdHelp 		db 	"help", 0x00
	cmdhInfo		db	"info", 0x00
    cmdOff          db  "off", 0x00
	cmdCls        db  "cls", 0x00
	txtVersion		db	"version", 0x00	;messages and other strings
	msgUnknownCmd	db	" Unknown command or bad file name! Plese type help to get 'help' menu", 0x00

	strHelpMsg0		db 	"     help  for help menu",0x00
	strHelpMsg1		db 	"     ver   for version",0x00
	strHelpMsg2		db 	"     info  for hardware informations",0x00
	strHelpMsg3		db 	"     cls  for Clear Screen",0x00
    strHelpMsg4     db  "     off   for shutdown", 0x00
	strhInfo		db	" -------  Hardware Information  ------- ",0x00
	strcpuid		db	" CPU Vender : ",0x00
	strvender		db	" CPU Vender :",0x00
	strproceType	db	" CPU Type :",0x00
	strmouseState	db	" Mouse state :",0x00
	strMouseNo		db	" Mouse not found",0x00
	strMouseYes		db	" Mouse found",0x00
	strserialportnumber	db	" Number of serial port :",0x00
	strserialnumber		db	" Serial Number :",0x00	

	strInfo			    db	"---------------------- Hardware Information ---------------------- ", 0x00
	strmemory		    db	" Base Memory size: ", 0x00
	strsmallextended	db	" Extended memory between(1M - 16M): ", 0x00
	strbigextended		db      " Extended memory above 16M: ", 0x00
	strCPUVendor		db	" CPU Vendor : ", 0x00
	strCPUdescription	db	" CPU description: ", 0x00
	strNotSupported		db	" Not supported.", 0x00
	strhdnumber		    db	" Number of hard drives: ",0x00
	strserialport1		db	" Base I/O address for serial port 1 (communications port 1 - COM 1): ", 0x00
	strtotalmemory		db	" Total memory: ", 0x00

	strcpufeatures	db	" CPU Features: ",0x00
	sse				db 	"SSE ", 0x00
	sse2 			db 'SSE2 ', 0x00
	sse3 			db 'SSE3 ', 0x00
	ssse3 			db 'SSSE3 ', 0x00
	sse41 			db 'SSE4.1 ', 0x00
	sse42 			db 'SSE4.2 ', 0x00
	aes				db 'AES ', 0x00
	avx 			db 'AVX ', 0x00
	strMouse0		db	"The Mouse Not Found",0x00
	strMouse1		db 	"The Mouse Found",0x00
	strmouse 		db 	" Mouse Status : ",0x00


	line1     db  " ", 0x00
	line2     db  " =============================================================================", 0x00
	line5     db  "                 _______            _____        _____   ", 0x00
	line6     db  "                 | ____ \          / ___ \      / ____|  ", 0x00 
	line7     db  "                 | |   \ \        / /   \ \    / /       ", 0x00
	line8     db  "                 | |___/ /  __   / /     \ \   \ \__     ", 0x00;
	line9     db  "                 |  ____/  |__|  | |     | |    \__ \    ", 0x00
	line10    db  "                 | |             \ \     / /       \ \   ", 0x00
	line11    db  "                 | |              \ \___/ /    ____/ /   ", 0x00
	line12    db  "                 |_|               \_____/    |_____/    ", 0x00
	line13    db  "                              Welcome to POS ", 0x00
	line14    db  "                       Developed By- Padma Gnanapriya, ", 0x00
	line15    db  "     a SOFTWARE ENGINEERING undergraduate From University Of Kelaniya ", 0x00
	line5A     db  "                 _______            ", 0x00
	line6A     db  "                 | ____ \           ", 0x00 
	line7A     db  "                 | |   \ \        ", 0x00
	line8A     db  "                 | |___/ /  __     ", 0x00;
	line9A     db  "                 |  ____/  |__|     ", 0x00
	line10A    db  "                 | |              ", 0x00
	line11A    db  "                 | |              ", 0x00
	line12A    db  "                 |_|                ", 0x00
	line5B     db  "                 _______            _____         ", 0x00
	line6B     db  "                 | ____ \          / ___ \       ", 0x00 
	line7B     db  "                 | |   \ \        / /   \ \        ", 0x00
	line8B     db  "                 | |___/ /  __   / /     \ \      ", 0x00;
	line9B     db  "                 |  ____/  |__|  | |     | |      ", 0x00
	line10B    db  "                 | |             \ \     / /         ", 0x00
	line11B    db  "                 | |              \ \___/ /      ", 0x00
	line12B    db  "                 |_|               \_____/     ", 0x00
	
	

[SEGMENT .bss]
	strUserCmd	resb	256		;buffer for user commands
	cmdChrCnt	resb	1		;count of characters
	strCmd0		resb	256		;buffers for the command components
	strCmd1		resb	256
	strCmd2		resb	256
	strCmd3		resb	256
	strCmd4		resb	256
	strCmd5		resb	256
	strcputype	resb	256
	strcpuserno	resb	256
	strVendorID	resb	16
	strBrand	resb	48
	basemem		resb	2
	extmem1		resb	2
	extmem2		resb	2

;********************end of the kernel code********************

;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/
