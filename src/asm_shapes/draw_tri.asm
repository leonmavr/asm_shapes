; given two clicks at points (x0, y0), (x1, y1)
; draws an isosceles triangle
; width is the horizontal difference between 
; the two clicks that had been captured
;			/\
;		       /  \
;		      /    \
;		     /      \
;	(x0,y0)--> +---------+ <--(x1,y1)
;	           <- width ->
; offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;             +4  +6  +8      +10        +12
; draw_tri (  x0, y0, width, rev_flag, int colour) 
; locals:
; -2	halfWidth
; -4	vertice_top	

draw_tri proc near

    push bp
    mov bp, sp
    sub sp, 4
    
    pusha           
   
    mov bx, [bp+8]  
    shr bx, 1
    mov [bp-2], bx			; width/2
    
    mov cx, [bp+8]
    mov [bp-4], 0			; top of triangle 

    loop7:    
    
        cmp cx, [bp-2]
        jg incr   
        dec [bp-4]
        jmp cont
        incr: 
        inc [bp-4]
        jmp cont
        cont: 
        cmp cx, 1
        je exit_triangle
                     
        mov bx, cx				; col
        push cx
        mov cx, [bp-4]
        loop8: 
            mov ax, cx
            cmp [bp+10], '0'
            jne skip_rev:
		neg ax			; orientation downwards
            skip_rev:
            push cx
            ; draw pixel
	    mov cx, bx			; col
            add cx, [bp+4]
            mov dx, ax			; row
            add dx, [bp+6]
            mov al, [bp+12] 	; 16-bit colour
            mov ah, 0ch 		; draw pixel INT
            int 10h 

            pop cx    
        
        loop loop8
        pop cx
        
    loop loop7
    
    exit_triangle:
    popa 
     
    mov sp, bp
    pop bp 
ret               
                  
draw_tri endp
