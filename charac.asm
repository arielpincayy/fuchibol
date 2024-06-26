include square.asm
include line.asm
include circle.asm

;i=fila,j=columna,t=team
player macro i,j,t,front 
    local no_eye,draw
    push bx
    cmp t,1
    mov bh, 0eh
    jz draw
    mov bh, 01h
    draw:
    mov color,bh
    circle i,j,7h,0eh
    mov bx,front
    cmp bx,1
    jnz no_eye
    mov bx,i
    mov x,bx
    mov bx,j
    mov y,bx
    add y,5
    sub x,3
    graph_pixel x,y,0h
    sub x,3
    graph_pixel x,y,0h
    no_eye:
    add j,9
    sub i,3
    line_vert 8,i,j,color
    sub j,8
    sub i,1
    line_vert 8,i,j,color 
    sub i,1
    sub j,8
    line_vert 8,i,j,color 
    sub i,1
    sub j,8
    line_vert 8,i,j,color 
    mov bx,i
    mov x,bx
    mov bx,j
    mov y,bx
    sub y,6
    add x,4
    line_hor 4,x,y,color
    sub x,14
    line_hor 4,x,y,color
    add x,2
    add y,6
    line_vert 6,x,y,0h
    add x,3
    sub y,6
    line_vert 6,x,y,0h
    pop bx
endm

