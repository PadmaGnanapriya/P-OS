
;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/

;*****************start of the kernel code***************
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

	call _display_endl
    mov si, strWelcomeMsg   ; load message
    mov al, 0x01            ; request sub-service 0x01
    int 0x21
	call _display_endl


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
	jne	_cmd_ver		;next command
	jmp _cmd_done
	
	; display version
	_cmd_ver:		
	mov si, strCmd0
	mov di, cmdVer
	mov cx, 4
	repe	cmpsb
	jne	_cmd_help		;next command
	
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


    ;********************************************************************************

	;display help
   	_cmd_help:		
	mov si, strCmd0
	mov di, cmdHelp
	mov cx, 4
	repe	cmpsb
	jne	_cmd_hardwareInfo		;next command

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



    ;********************************************************************************

	;Display Hardware Details
    	_cmd_hardwareInfo:
	mov si, strCmd0
	mov di, cmdhInfo
	mov cx, 5
	repe	cmpsb
	jne	_cmd_reboot		;next command

    ;^^^^^^^^^^^^^^^^^^^^^^^^^^

_display_hardware_info:			; Procedure for printing Hardware info
	
	push ax
	push bx
	push cx
	push dx
	push es
	push si

	call _display_endl
	call _display_endl
	call _display_endl
	
	mov si, strmemory	; Prints base memory string
	mov al, 0x01
	int 0x21

	; Reading Base Memory -----------------------------------------------
	push ax
	push dx
	
	int 0x12		; call interrupt 12 to get base mem size
	mov dx,ax 
	mov [basemem] , ax
	call _print_dec		; display the number in decimal
	mov al, 0x6b
        mov ah, 0x0E            ; BIOS teletype acts on 'K' 
        mov bh, 0x00
        mov bl, 0x07
        int 0x10
	
	pop dx
	pop ax

	; Reading extended Memory
	call _display_endl
        mov si, strsmallextended
        mov al, 0x01
        int 0x21

	xor cx, cx		; Clear CX
	xor dx, dx		; clear DX
	mov ax, 0xE801
	int 0x15		; call interrupt 15h
	mov dx, ax		; save memory value in DX as the procedure argument
	mov [extmem1], ax
	call _print_dec		; print the decimal value in DX
	mov al, 0x6b
        mov ah, 0x0E            ; BIOS teletype acts on 'K'
        mov bh, 0x00
        mov bl, 0x07
        int 0x10

	xor cx, cx		; clear CX
        xor dx, dx		; clear DX
        mov ax, 0xE801
        int 0x15		; call interrupt 15h
	mov ax, dx		; save memory value in AX for division
	xor dx, dx
	mov si , 16
	div si			; divide AX value to get the number of MB
	mov dx, ax
	mov [extmem2], ax
	push dx			; save dx value

	call _display_endl
        mov si, strbigextended
        mov al, 0x01
        int 0x21
	
	pop dx			; retrieve DX for printing
	call _print_dec
	mov al, 0x4D
        mov ah, 0x0E            ; BIOS teletype acts on 'M'
        mov bh, 0x00
        mov bl, 0x07
        int 0x10

	call _display_endl
	mov si, strtotalmemory
	mov al, 0x01
	int 0x21

	; total memory = basemem + extmem1 + extmem2
	mov ax, [basemem]	
	add ax, [extmem1]	; ax = ax + extmem1
	shr ax, 10
	add ax, [extmem2]	; ax = ax + extmem2
	mov dx, ax
	call _print_dec
	mov al, 0x4D            
	mov ah, 0x0E            ; BIOS teletype acts on 'M'
	mov bh, 0x00
	mov bl, 0x07
	int 0x10



	;CPU Information --------------------------------------------------------------------------
	call _display_endl
	mov si, strCPUVendor
	mov al, 0x01
	int 0x21
	mov eax, 0x00000000 	; set eax register to get the vendor
	cpuid		 	
	mov eax, ebx		; prepare for string saving
	mov ebx, edx
	mov edx, 0x00
	mov si, strVendorID
	call _save_string

	mov si, strVendorID	 ;print string
	mov al, 0x01
	int 0x21

	call _display_endl
	mov si, strCPUdescription
	mov al, 0x01
	int 0x21

	mov eax, 0x80000000		; First check if CPU support this 
	cpuid
	cmp eax, 0x80000004
	jb _cpu_not_supported		; if not supported jump to function end
	mov eax, 0x80000002		; get first part of the brand
	mov si, strBrand
	cpuid
	call _save_string
	add si, 16
	mov eax, 0x80000003		; get second part of the brand
	cpuid
	call _save_string
	add si, 16
	mov eax, 0x80000004		; get third part of the brand
	cpuid
	call _save_string

	mov si, strBrand		; print the saved Brand string
	mov al, 0x01
	int 0x21
	
_hard_info:
	
	call _display_endl
	mov si, strhdnumber
        mov al, 0x01
        int 0x21

	mov ax,0040h             ; look at 0040:0075 for a number
	mov es,ax                ;
	mov dl,[es:0075h]        ; move the number into DL register
	add dl,30h		; add 48 to get ASCII value            
	mov al, dl
        mov ah, 0x0E            ; BIOS teletype acts on character 
        mov bh, 0x00
        mov bl, 0x07
        int 0x10

_mouse_status:

		call _display_endl
		mov si, strmouse
		mov al, 0x01
		int 0x21

		mov ax, 0
		int 33h
		test ax, 0FFFFh
		jz ok
		
		mov si, strMouse0
		mov al, 0x01
		int 0x21
		
ok:
		mov si, strMouse1
		mov al, 0x01
		int 0x21

_serial_ports:
	call _display_endl
	mov si, strserialportnumber
	mov al, 0x01
	int 0x21

	mov ax, [es:0x10]
	shr ax, 9
	and ax, 0x0007
	add al, 30h
	mov ah, 0x0E            ; BIOS teletype acts on character
	mov bh, 0x00
	mov bl, 0x07
	int 0x10


	; Reading base I/O addresses
	;Base I/O address for serial port 1 (communications port 1 - COM 1)
	mov ax, [es:0000h]	; Read address for serial port 1
	cmp ax, 0
	je _end
	call _display_endl
	mov si, strserialport1
        mov al, 0x01
        int 0x21	

	mov dx, ax
	call _print_dec


jmp _cpu_Features


	_cpu_not_supported:
	mov si, strNotSupported
	mov al, 0x01
	int 0x21
	
	
	;End of processor info


	_cpu_Features:
		call _display_endl
		mov si, strcpufeatures
		mov al, 0x01
		int 0x21

		

		checksse:
			test edx, 00000010000000000000000000000000b
			jz checksse2
			mov si, sse
			mov al, 0x01
			int 0x21
			

		checksse2:
			call _display_space
			test edx, 00000100000000000000000000000000b
			jz checksse3
			
			mov si, sse2
			mov al, 0x01
			int 0x21
			
			
		checksse3:
			test ecx, 00000000000000000000000000000001b
			jz checkssse3
			mov si, sse3
			mov al, 0x01
			int 0x21
			

		checkssse3:
			test ecx, 00000000000000000000001000000000b
			jz checksse41
			mov si, ssse3
			mov al, 0x01
			int 0x21
			


		checksse41:
			test ecx, 00000000000010000000000000000000b
			jz checksse42
			mov si, sse41
			mov al, 0x01
			int 0x21
			

		checksse42:
			test ecx, 00000000000100000000000000000000b
			jz checkaes
			mov si, sse42
			mov al, 0x01
			int 0x21
			

		checkaes:
			test ecx, 00000010000000000000000000000000b
			jz checkavx
			mov si, aes
			mov al, 0x01
			int 0x21
		
		checkavx:
			test ecx, 00010000000000000000000000000000b
			jz _end
			mov si, avx
			mov al, 0x01
			int 0x21

			
_end:
	;Base I/O address for serial port 1 (communications port 1 - COM 1)	
	
	
jmp _cmd_done
	call _display_endl

	pop si
        pop es
        pop dx
        pop cx
        pop bx
        pop ax

	ret

	_print_dec:
	push ax			; save AX
	push cx			; save CX
	push si			; save SI
	mov ax,dx		; copy number to AX
	mov si,10		; SI is used as the divisor
	xor cx,cx		; clear CX

_non_zero:

	xor dx,dx		; clear DX
	div si			; divide by 10
	push dx			; push number onto the stack
	inc cx			; increment CX to do it more times
	or ax,ax		; clear AX
	jne _non_zero		; if not go to _non_zero

_prepare_digits:

	pop dx			; get the digit from DX
	add dl,0x30		; add 30 to get the ASCII value
	call _print_char	; print char
	loop _prepare_digits	; loop till cx == 0

	pop si			; restore SI
	pop cx			; restore CX
	pop ax			; restore AX
	ret                      

_print_char:
	push ax			; save AX 
	mov al, dl
        mov ah, 0x0E		; BIOS teletype acts on printing char
        mov bh, 0x00
        mov bl, 0x07
        int 0x10

	pop ax			; restore AX
	ret

_save_string:
	mov dword [si], eax
	mov dword [si+4], ebx
	mov dword [si+8], ecx
	mov dword [si+12], edx

	ret





	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^	

	; Reboot shell
	_cmd_reboot:		
	mov si, strCmd0
	mov di, cmdReBoot
	mov cx, 5
	repe	cmpsb
	jne	_cmd_off		;next command

	;je _shell_end			;exit from shell
	jmp _shell_end
	jmp _cmd_done



    	; Shut down POS
	_cmd_off:		
	mov si, strCmd0
	mov di, cmdOff
	mov cx, 4
	repe	cmpsb
	jne	_cmd_unknown		;next command


	je _shutdown			;Power off

    _shutdown:
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15



	_cmd_unknown:
	call _display_endl
	mov si, msgUnknownCmd		;unknown command
	mov al, 0x01
    int 0x21



	_cmd_done:

	;call _display_endl
	jmp _shell_begin
	
	_shell_end:
	ret

_get_command:
	;initiate count
	mov BYTE [cmdChrCnt], 0x00
	mov di, strUserCmd

	_get_cmd_start:
	mov ah, 0x10		;get character
	int 0x16

	cmp al, 0x00		;check if extended key
	je _extended_key
	cmp al, 0xE0		;check if new extended key
	je _extended_key

	cmp al, 0x08		;check if backspace pressed
	je _backspace_key

	cmp al, 0x0D		;check if Enter pressed
	je _enter_key

	mov bh, [cmdMaxLen]		;check if maxlen reached
	mov bl, [cmdChrCnt]
	cmp bh, bl
	je	_get_cmd_start

	;add char to buffer, display it and start again
	mov [di], al			;add char to buffer
	inc di					;increment buffer pointer
	inc BYTE [cmdChrCnt]	;inc count

	mov ah, 0x0E			;display character
	mov bl, 0x07
	int 0x10
	jmp	_get_cmd_start

	_extended_key:			;extended key - do nothing now
	jmp _get_cmd_start

	_backspace_key:
	mov bh, 0x00			;check if count = 0
	mov bl, [cmdChrCnt]
	cmp bh, bl
	je	_get_cmd_start		;yes, do nothing
	
	dec BYTE [cmdChrCnt]	;dec count
	dec di

	;check if beginning of line
	mov	ah, 0x03		;read cursor position
	mov bh, 0x00
	int 0x10

	cmp dl, 0x00
	jne	_move_back
	dec dh
	mov dl, 79
	mov ah, 0x02
	int 0x10

	mov ah, 0x09		; display without moving cursor
	mov al, ' '
    mov bh, 0x00
    mov bl, 0x07
	mov cx, 1			; times to display
    int 0x10
	jmp _get_cmd_start

	_move_back:
	mov ah, 0x0E		; BIOS teletype acts on backspace!
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
	mov ah, 0x09		; display without moving cursor
	mov al, ' '
    mov bh, 0x00
    mov bl, 0x07
	mov cx, 1			; times to display
    int 0x10
	jmp _get_cmd_start

	_enter_key:
	mov BYTE [di], 0x00
	ret

_split_cmd:
	;adjust si/di
	mov si, strUserCmd
	;mov di, strCmd0

	;move blanks
	_split_mb0_start:
	cmp BYTE [si], 0x20
	je _split_mb0_nb
	jmp _split_mb0_end

	_split_mb0_nb:
	inc si
	jmp _split_mb0_start

	_split_mb0_end:
	mov di, strCmd0

	_split_1_start:			;get first string
	cmp BYTE [si], 0x20
	je _split_1_end
	cmp BYTE [si], 0x00
	je _split_1_end
	mov al, [si]
	mov [di], al
	inc si
	inc di
	jmp _split_1_start

	_split_1_end:
	mov BYTE [di], 0x00

	;move blanks
	_split_mb1_start:
	cmp BYTE [si], 0x20
	je _split_mb1_nb
	jmp _split_mb1_end

	_split_mb1_nb:
	inc si
	jmp _split_mb1_start

	_split_mb1_end:
	mov di, strCmd1

	_split_2_start:			;get second string
	cmp BYTE [si], 0x20
	je _split_2_end
	cmp BYTE [si], 0x00
	je _split_2_end
	mov al, [si]
	mov [di], al
	inc si
	inc di
	jmp _split_2_start

	_split_2_end:
	mov BYTE [di], 0x00

	;move blanks
	_split_mb2_start:
	cmp BYTE [si], 0x20
	je _split_mb2_nb
	jmp _split_mb2_end

	_split_mb2_nb:
	inc si
	jmp _split_mb2_start

	_split_mb2_end:
	mov di, strCmd2

	_split_3_start:			;get third string
	cmp BYTE [si], 0x20
	je _split_3_end
	cmp BYTE [si], 0x00
	je _split_3_end
	mov al, [si]
	mov [di], al
	inc si
	inc di
	jmp _split_3_start

	_split_3_end:
	mov BYTE [di], 0x00

	;move blanks
	_split_mb3_start:
	cmp BYTE [si], 0x20
	je _split_mb3_nb
	jmp _split_mb3_end

	_split_mb3_nb:
	inc si
	jmp _split_mb3_start

	_split_mb3_end:
	mov di, strCmd3

	_split_4_start:			;get fourth string
	cmp BYTE [si], 0x20
	je _split_4_end
	cmp BYTE [si], 0x00
	je _split_4_end
	mov al, [si]
	mov [di], al
	inc si
	inc di
	jmp _split_4_start

	_split_4_end:
	mov BYTE [di], 0x00

	;move blanks
	_split_mb4_start:
	cmp BYTE [si], 0x20
	je _split_mb4_nb
	jmp _split_mb4_end

	_split_mb4_nb:
	inc si
	jmp _split_mb4_start

	_split_mb4_end:
	mov di, strCmd4

	_split_5_start:			;get last string
	cmp BYTE [si], 0x20
	je _split_5_end
	cmp BYTE [si], 0x00
	je _split_5_end
	mov al, [si]
	mov [di], al
	inc si
	inc di
	jmp _split_5_start

	_split_5_end:
	mov BYTE [di], 0x00

	ret

_display_space:
	mov ah, 0x0E                            ; BIOS teletype
	mov al, 0x20
    mov bh, 0x00                            ; display page 0
    mov bl, 0x07                            ; text attribute
    int 0x10                                ; invoke BIOS
	ret

_display_endl:
	mov ah, 0x0E		; BIOS teletype acts on newline!
    mov al, 0x0D
	mov bh, 0x00
    mov bl, 0x07
    int 0x10
	mov ah, 0x0E		; BIOS teletype acts on linefeed!
    mov al, 0x0A
	mov bh, 0x00
    mov bl, 0x07
    int 0x10
	ret

_display_prompt:
	mov si, strPrompt
	mov al, 0x01
	int 0x21
	ret

[SEGMENT .data]
    strWelcomeMsg   db  "        Welcome to P-OS", 0x00
	strPrompt		db	" User>>> ", 0x00
	cmdMaxLen		db	255			;maximum length of commands
	strOsName		db	" P-OS", 0x00	;OS details
	strMajorVer		db	"2", 0x00
	strMinorVer		db	".0", 0x00
	cmdVer			db	"ver", 0x00		; internal commands
	cmdReBoot    	db	"boot", 0x00
	cmdHelp 		db 	"help", 0x00
	cmdhInfo		db	"info", 0x00
    cmdOff          db  "off", 0x00
	txtVersion		db	"version", 0x00	;messages and other strings
	msgUnknownCmd	db	" Unknown command or bad file name! Plese type help to get 'help' menu", 0x00

	strHelpMsg0		db 	"     help  for help menu",0x00
	strHelpMsg1		db 	"     ver   for version",0x00
	strHelpMsg2		db 	"     info  for hardware informations",0x00
	strHelpMsg3		db 	"     boot  for Reboot",0x00
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
