include square.asm
include line.asm


circle macro i,j,radio,color
    local w
    push bx
    mov bx,0h
    mov e,0h
    mov bh,radio
    sub bh,2
    line_vert bh,i,j,color
    dec i
    mov cx,j
    sub cx,radio
    inc cx
    mov j,cx
    w:
    line_vert radio,i,j,color
    dec i
    inc e 
    mov cx,j
    sub cx,radio
    mov j,cx
    cmp bh,e
    jnz w
    
    inc j
    line_vert bh,i,j,color
    
    sub j,radio
    add i,radio
endm
