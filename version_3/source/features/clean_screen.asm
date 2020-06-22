clean_screen_:

              
    mov si, strCmd0
    mov di, cmdCls
    mov cx, 4
    repe cmpsb
     	        	;next command
        
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    call _display_endl
    mov bh, 0
    mov dl, 0
    mov dh, 00
    mov ah, 02
    int 10h
 
    mov si,line1   
    mov al, 0x01           
    int 0x21
    call _display_endl

    mov si, strWelcomeMsg   ; load message
    mov al, 0x01            ; request sub-service 0x01
    int 0x21
	call _display_endl
    jmp _cmd_done
  ret
    
