include square.asm
include line.asm
include circle.asm

player macro i,j,color,front
    local no_eye
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
    no_eye:
    graph_pixel x,y,0h
    sub x,3
    graph_pixel x,y,0h
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
    line_vert 6,x,y,0fh
    add x,3
    sub y,6
    line_vert 6,x,y,0fh
endm

