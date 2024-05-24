include square.asm

line_hor macro l,i,j,color

    local lar
    mov d,l
    
    lar: 
    square i,j,1,color
    dec d
    jnz lar
    
endm


line_vert macro l,i,j,color

    local alt
    mov d,l
    
    alt:
    dec i
    square i,j,1,color
    inc j
    dec d
    jnz alt
    
endm