welcome:

clean_:
              
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

    mov si, line2   
        mov al, 0x01           
        int 0x21
        call _display_endl

    mov si, line1   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line1   
        mov al, 0x01           
        int 0x21
        call _display_endl

    mov si, line5   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line6  
        mov al, 0x01            
        int 0x21
        call _display_endl


    mov si, line7   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line8   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line9   
        mov al, 0x01            
        int 0x21
        call _display_endl

     mov si, line10   
        mov al, 0x01            
        int 0x21
        call _display_endl

     mov si, line11   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line12   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line1   
        mov al, 0x01           
        int 0x21
        call _display_endl

    mov si, line1  
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line1 
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line13  
        mov al, 0x01           
        int 0x21
        call _display_endl

    mov si, line1   
        mov al, 0x01            
        int 0x21
        call _display_endl
    
    mov si, line1   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line14   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line1   
        mov al, 0x01           
        int 0x21
        call _display_endl

    mov si, line15   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line1  
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line1  
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line2  
        mov al, 0x01            
        int 0x21
        call _display_endl



;Sleep small time

        mov    ax,500  ; 
    wta:     
        mov    cx,65000
    wt:    
        nop
        loop   wt
         dec   ax
         jnz   wta


call clean_screen_
  ret

 
 