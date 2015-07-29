; draws a circle given its centre (x0, y0) and
; point (x0 + r, y0), where r is the radius
; method in brief:
; for xi =  x0:x0+r {
;	for yi = y0:y0+r {
;		if (((xi-x0)^2+(yi-y0)^2) <= r^2) draw(xi, yi)
;	}
; }
; offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;           +4    +6  +8              +10
;draw_cir ( color, x0, y0, signed int rad)
; local vars:
; -2    x0		(y centre)
; -4    y0		(x centre)
; -6    x_start	(x top to start drawing from)
; -8    y_start (y top to start drawing from)
; -10   rad^2
; -12   2*rad
; -14   temp_sum

draw_cir proc near
    push bp
    mov bp, sp    
    push bx
    sub sp, 14
    push bx
    
    cmp [bp+10], 0
    jge skip_neg_rad
    neg [bp+10]
    skip_neg_rad:
   
    mov bx, [bp+6]
    sub bx, [bp+10] 
    mov [bp-2], bx  	; x_centre
    sub bx, [bp+10]
    mov [bp-6], bx  	; x_start
     
    mov bx, [bp+8]
    sub bx, [bp+10]
    mov [bp-4], bx  	; y0 (centre)
    sub bx, [bp+10]
    mov [bp-8], bx  	; ystart (top left)
   
    mov ax, [bp+10]
    mul ax
    mov [bp-10], ax 	; rad^2
   
    mov bx, [bp+10]
    add bx, [bp+10]
    mov [bp-12], bx 	; 2*rad   

    mov cx, [bp-12]
    loop4:
       
        mov cx, [bp-12]
        loop3:
        ; draw a pixel  
        mov ax, cx
        push cx
        draw:

            push ax
            mov ax,[bp+10] 		; rad
            sub ax, cx
            
            mul ax
            mov [bp-14], ax		; temp sum
            
            mov ax, [bp+10]		; rad
            sub ax, bx
            
            mul ax
            add [bp-14], ax
            
            mov ax, [bp-10]		; rad^2 
            
            cmp [bp-14], ax		; if inside the disk...
            jg skip
  
				pop ax

				push cx
			   
				mov cx, [bp-2]      ; col
				add cx, ax
				mov dx, [bp-4]      ; row
				add dx, bx 
				mov al, [bp+4]      ; colour
				mov ah, 0ch         ; draw pixel INT
				int 10h

            skip:
              
            pop cx
            loop loop3    
        dec bx
        cmp bx, 0
    jg loop4
   
    pop bx
    mov sp, bp  
   
    pop bp
    ret  
draw_cir endp   
