;*****************start of the kernel code***************
[org 0x0000]
[bits 16]

[SEGMENT .text]
    mov ax, 0x0100                          ;location where kernel is loaded
    mov ds, ax
    mov es, ax
    
    cli
    mov ss, ax                              ;stack segment
    mov sp, 0xFFFF                          ;stack pointer at 64k limit
    sti
    
    mov si, strWelcomeMsg                   ;load message
    call    _disp_str
    
    push dx									; install interrupt routine for int 8 (timer tick)
    push es
    xor ax, ax
    mov es, ax
    cli
    mov word [es:0x8*4], _int0x8			; setup our OS services
    mov [es:0x8*4+2], cs
    sti
    pop es
    pop dx


    mov ah, 0x00
    int 0x16                                ; await keypress using BIOS service
    int 0x19                                ; reboot

_int0x8:
	mov si, strAuthor						; load timer message
	call _disp_str
    iret
        
_disp_str:
    lodsb                                   ; load next character
    or  al, al                              ; test for NUL character
    jz  .DONE
    mov ah, 0x0E                            ; BIOS teletype
    mov bh, 0x00                            ; display page 0
    mov bl, 0x07                            ; text attribute
    int 0x10                                ; invoke BIOS
    jmp _disp_str
.DONE:
    ret
   
[SEGMENT .data]
    strWelcomeMsg   db  "     Welcome to P-OS...   ", 0x00
    strAuthor	    db  "  :-  Padma Gnanapriya  ",0x00

[SEGMENT .bss]

;********************end of the kernel code********************
