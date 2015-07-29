; draws a rectangle in the frame defined
; by the two clicks captured prevously
; offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;                +4       +6     +8      +10     +12
;draw_rec( int color, int x0, int y0, int x1, int y1)
; locals:
; -2    x_starting (top vertice)  
; -4    width
; -6    y_starting (top vertice)
; -8    height		 

draw_rec proc near
    push bp				; stores ret addr
    mov bp, sp 
    sub sp, 8
    pusha
	
    mov bx, [bp+6]      ; x0
    sub bx, [bp+10]     ; x0-x1
    cmp bx, 0           ; x0<x1
    jl x0_l_x1
    
    ; x0>x1
    mov bx, [bp+10]     ; x1
    mov [bp-2], bx      ; x_starting    =   x1
    sub bx, [bp+6]
    neg bx
    mov [bp-4], bx      ; width
    jmp x_done
    
    
    ; x0<x1
    x0_l_x1:
    mov bx, [bp+6]      ; x0
    mov [bp-2], bx      ; x_st = x0
    sub bx, [bp+10]
    neg bx
    mov [bp-4], bx      ; width
    
    x_done:
            
    mov bx, [bp+8]     ; y1
    sub bx, [bp+12]    ; y1-y0
    cmp bx, 0          ; y1<y0
    jl y0_l_y1
    
    mov bx, [bp+8]      ; y0
    mov [bp-6], bx      ; y_st = y0
    sub bx, [bp+12]
    ;neg bx
    mov [bp-8], bx      ; h
    jmp y_done
    
    ; y0 < y1
    y0_l_y1:
    mov bx, [bp+12]      ; y0
    mov [bp-6], bx      ; y_st = y0
    sub bx, [bp+8]
    mov [bp-8], bx      ; height
 
    y_done:
    
    mov cx, [bp-8]
    loop1:
        push cx 
        mov bx, cx 
        ;neg bx
        mov cx, [bp-4]
        loop2: 
            push cx
            add cx, [bp-2] 		; (c)ol
            mov dx, bx			; row
            add dx, [bp-6]
            sub dx, [bp-8]		
            mov al, [bp+4]      ; colour 00h to 0fh
            mov ah, 0ch         ; draw pixel
            int 10h
            pop cx 
        loop loop2
        pop cx
    loop loop1
    
    popa
    mov sp, bp  
    pop bp
    ret  
draw_rec endp 

jmp get_key1

