;i=fila,j=columna
pos_cursor macro i,j 
    push ax 
    push bx 
    push dx  
    mov ah,02h
    mov bh,0 
    mov dh,i
    mov dl,j
    int 10h
    pop dx  
    pop bx
    pop ax  
endm