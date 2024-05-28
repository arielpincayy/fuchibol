delay macro t
    local loop, delay_loop
    push cx
    push dx
    mov dx,t
    loop:
    mov cx, 0ffffh  
    delay_loop:
    dec cx 
    cmp cx,0h    
    jnz delay_loop  
    dec dx
    cmp dx,0h
    jnz loop
    pop dx
    pop cx

endm