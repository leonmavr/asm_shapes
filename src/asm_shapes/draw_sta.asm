; draws an  asterisk - an X overlaid on a cross in one loops
; draws an asterisk withing the frame defined
; by the two clicks captured previously
; arg [bp+8] (length) is the horizontal difference between two clicks
;offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;            +4  +6   +8       +10
; draw_stat( x0, y0, length, colour)
; locals:
; -2;   2*length
; -4;   length/2
; -6;   length/4


draw_sta proc near
    
    push bp
    mov bp, sp
    sub sp, 6
    push cx
    
    
    ; make sure [bp+8] is positive
    cmp [bp+8], 0
    jge skip_neg_star
    neg [bp+8]
    skip_neg_star:
    
    mov cx, [bp+8]
    shl cx, 1 
    mov [bp-2], cx 				; 2*length
    pop cx
    
    
    mov bx, [bp+8]
    shr bx, 1
    mov [bp-4], bx      		; length/2 
    
    shr bx, 1
    mov [bp-6], bx
    
    mov cx, [bp+8]
    
    loop5:
        push cx
        row_:
        add cx, [bp+4]  		; (c)ol
        ;sub cx, [bp-4]
        mov dx, [bp+6]	    	; row
        mov al, [bp+10] 		; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel
        int 10h       
        pop cx
        
        mov bx, cx
        push cx
        
        col_:       
        mov cx, [bp+4]			; col
        add cx, [bp-4]
        mov dx, [bp+6]			; row
        add dx, bx
        sub dx, [bp-4]
        mov al, [bp+10]			; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel
        int 10h
        
        
        diag1_:
        mov cx, [bp+4]
        ;sub cx, [bp-4]  
        add cx, bx
        mov dx, [bp+6]
        sub dx, [bp-4]
        add dx, bx 
        mov al, [bp+10]			; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel 
        int 10h 
        
        
        diag2_:
        mov cx, [bp+4]
        ;sub cx, [bp-4]  
        add cx, bx
        mov dx, [bp+6]
        sub dx, bx
        add dx, [bp-4]
        mov al, [bp+10] 		; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel 
        int 10h         
        
        pop cx 
       
        
    loop loop5
     
    
    
    mov sp, bp    
    pop bp
    ret    
    
draw_sta endp   