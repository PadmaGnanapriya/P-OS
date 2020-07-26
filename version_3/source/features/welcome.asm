
;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/

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

    mov si, line5A   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line6A  
        mov al, 0x01            
        int 0x21
        call _display_endl


    mov si, line7A   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line8A   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line9A   
        mov al, 0x01            
        int 0x21
        call _display_endl

     mov si, line10A   
        mov al, 0x01            
        int 0x21
        call _display_endl

     mov si, line11A   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line12A   
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

call sleep_small

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

    mov si, line5B   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line6B  
        mov al, 0x01            
        int 0x21
        call _display_endl


    mov si, line7B   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line8B   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line9B   
        mov al, 0x01            
        int 0x21
        call _display_endl

     mov si, line10B   
        mov al, 0x01            
        int 0x21
        call _display_endl

     mov si, line11B   
        mov al, 0x01            
        int 0x21
        call _display_endl

    mov si, line12B   
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



call sleep_small

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

call sleep_small

call sleep_small
call clean_screen_
  ret


    sleep_small:
        mov    ax,230  ; 
    wtaz:     
        mov    cx,65000
    wtz:    
        nop
        loop   wtz
         dec   ax
         jnz   wtaz
        ret


;   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
;   Read the full article from here: 
;   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
;   Get full source code here:
;   https://github.com/PadmaGnanapriya/P-OS/
 
 
