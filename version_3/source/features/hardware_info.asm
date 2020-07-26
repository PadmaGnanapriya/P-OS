
;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/

	;Display Hardware Details
_cmd_hardwareInfo:
	mov si, strCmd0
	mov di, cmdhInfo
	mov cx, 4
	repe	cmpsb
	jne	_cmd_clear		;next command
	


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


	
;jmp _cmd_done	

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



;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/

