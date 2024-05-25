graph_pixel macro i,j,color 
    mov ah,00h
    mov ah,0ch
    mov al,color
    mov cx,i
    mov dx,j
    int 10h    
endm 

square macro i,j,h,color
    local height,width  
    mov a,0 
    mov b,0
    width: 
    push j
    height:
    inc j 
    inc b
    graph_pixel i,j,color 
    cmp b,h
    jnz height 
    pop j   
    mov b,0
    inc i     
    inc a
    cmp a,h
    jnz width 
endm

