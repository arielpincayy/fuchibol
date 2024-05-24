pos_cursor macro i,j   
    mov ah,02h
    mov dh,i
    mov dl,j
    int 10h
endm