name "shapes"   ; output file name (max 8 chars for DOS compatibility) 
 
get_key macro 
       
    local get_key
        
    get_key:
        
        ; check for keystroke in keyboard buffer:
        mov ah, 1
        int 16h
    jz  get_key 
    
    ; remove keystroke from buffer
    mov ah, 0
    int 16h
    ; keystroke stored at al 
endm

print_str macro str 
    push ax
    
    local next_char, stop_printing 
    lea si, str
    next_char:
        mov al, [si]   
        cmp al, 0           
    je  stop_printing 
        mov ah, 0eh
        int 10h 
        inc si
    jmp next_char
    stop_printing:
    
    pop ax
endm 


#org  100h               ; set location counter to 100h
 
    jmp start
    
    coords      dw 0,0,0,0,0 
    colour      dw 00h    
    keystr      dw 0 
    rev_flag    dw 0 
    char_newl   dw 0ah
    ; null-trminated strings
    str1        db  'Instructions:', 0dh, 0ah, 0               
    str2        db  'Key 1 > [1] Rectangle [2] Circle [3] Star [4] Triangle [other] Quit', 0dh, 0ah, 0
    str3        db  'Key 2 > [0-9] Colour', 0dh, 0ah, 0
    str4        db  'Key 3 > For triangle: [0] Normal [1] Reversed', 0dh, 0ah, 0
    str5        db  'Click > Click at two points to draw shape', 0dh, 0ah, 0
    ; wait for keypress    
    xor ah, ah
    int 16h 
     
    start: 
    
    ;---------------------------------------------
    ; print instructions
    print_str str1
    print_str str2
    print_str str3
    print_str str4
    print_str str5
       
    ; set video mode to 13h - 320x200
    mov ah, 0
    mov al, 13h
    int 10h  
       
    get_key1:
    ;--------------------------------------------- 
    ; key 1; select shape
    get_key                 ; output as char at al
    lea si, keystr
    mov [si], al
    mov [si+1], 0
    
    ;--------------------------------------------- 
    ; key 2; select colour
    get_key             ; output at al
    sub al, '0'         ; char to int
    lea si, colour
    mov [si], al
    mov [si+1], 0
       
    ;---------------------------------------------
    ; key 3; 0 = normal triangle, !0 = reversed
    get_key             ; output at al
    lea si, rev_flag
    mov [si], al
    mov [si+1], 0
    
    xor ax, ax 
    xor bx, bx
    xor si, si 
    
    lea si, coords     
    
    ;---------------------------------------------
    get_click:
        ; wait for click
        ; (x,2*y) output at bx, cx
        ; get 2 clicks in total
            push ax
            
            mov ax,3
            int 33h
            pop ax
         
            cmp bx, 1
        jne get_click
        
        push bx
        
        ; si points at coords
        add si,2
        shr cx, 1        ; cx originaly holds 2*y...
        mov [si], cx     ; store x

        add si,2
        mov [si], dx     ; store y
        
        pop bx
        
        lea ax, coords
        sub ax, si
        neg ax
    
        cmp ax,4 
    jle get_click
    lea si, coords      ; coords = [0, x0, y0, x1, y1] 
    
    ;---------------------------------------------
    cmp [keystr], '1' 
    je  case_rec
    cmp [keystr], '2'
    je  case_cir
    cmp [keystr], '3'
    je  case_tri        
    cmp [keystr], '4'
    je  case_sta
    jmp exit_all       

    ;---------------------------------------------
    exit_all:
    ; wait for keypress    
    xor ah, ah
    int 16h 
    
    ; return to text mode:
    mov ah, 00
    mov al, 03 ;text mode 3
    int 10h 

ret  


case_rec:
    push [si+8]
    push [si+6]
    push [si+4]
    push [si+2] 
    push [colour] 
    call draw_rec 
    add sp, 10
jmp get_key1

case_cir:
    mov ax, [si+6]
    sub ax, [si+2]
    push ax
    push [si+4]
    push [si+2]
    push [colour] 
    call draw_cir
    add sp, 8
jmp get_key1 

case_tri:
    push [colour]
    push [rev_flag]
    mov ax, [si+6]
    sub ax, [si+2]
    push ax
    push [si+4]
    push [si+2]
    call draw_tri
    add sp, 10 
jmp get_key1

case_sta:
    push    [colour]
    mov     ax, [si+6]
    sub     ax, [si+2]
    push    ax
    push    [si+4]
    push    [si+2]
    call    draw_sta
    add     sp, 8
jmp get_key1

include '.\asm_shapes\draw_rec.asm'
include '.\asm_shapes\draw_cir.asm'
include '.\asm_shapes\draw_tri.asm'
include '.\asm_shapes\draw_sta.asm'
