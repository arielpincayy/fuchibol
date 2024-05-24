include square.asm
include line.asm
include charac.asm
include circle.asm
include delay.asm
include cursor.asm

.model small
.stack 100h         
         
.data 
    wel db "Welcome to the fuchibol$"  
    choose_team_title db "Choose your team: $"  
    choose_team db "Idolosh(1)    Coquetash(2)$" 
    press_key db "Press a key to continue$"
    tia_destiny db "El destino del TIA esta en tus manos$"
    cinco_cero db "En tus manos esta el vengar el cincocero$"
    choose_your_kickers db "Escoge tus pateadores$"
    choose_your_kickers_inst db "S: Escoger   D: Siguiente$"
    missing_kickers db "Faltan pateadores, escoge de nuevo$"
    
    idolosh_team db "Burrai,Vargas,Rodriguez,Sosa,Chala,Souza,Trindade,Corozo,Solano,Kitu,Polaco,$"
    coquetash_team db "Ortiz,Caicedo,Leguizamon,Leon,Cortez,Cortez,Erbes,Garces,Meli,Carabali,Ruiz,Castelli,$"
    kickers dw 5 dup(0)

    team db ?
    x dw ?
    y dw ?
    i dw ?
    j dw ?
    a db ? 
    b db ?
    d db ?
    e db ?
    

.code
main proc
    mov ax, @data
    mov ds, ax
    
    call erase
    
    mov ax,013h 
    int 10h
    
    mov a,11
    mov b,8
    mov d,0h
    mov x,1h
    lea di,wel
    writting:
    pos_cursor a,b
    mov ah,0ah
    mov bx,x
    mov cx,1h
    mov al,[di]
    int 10h
    delay 3h
    inc b
    inc di
    inc x
    cmp x,4h
    jnz next_color
    mov x,1h
    next_color:
    inc d
    cmp d,23
    jnz writting
    delay 10
    call erase
    
    
    mov a,2
    mov b,9
    pos_cursor a,b
    lea dx, wel 
    mov ah, 09h       
    int 21h 
    
    mov a,7
    mov b,8
    pos_cursor a,b
    lea dx, choose_team 
    mov ah, 09h       
    int 21h 
    
    mov a,9
    mov b,11
    pos_cursor a,b
    lea dx, choose_team_title 
    mov ah, 09h       
    int 21h 
    
    choose:
    mov a,11
    mov b,100
    pos_cursor a,b
    mov ah,1
    int 21h
    cmp al,31h
    jz choosen
    cmp al,32h
    jz choosen
    jmp choose
    choosen:
    sub al,30h
    mov team,al

    delay 10
    call erase
    
    
    cmp team,1h
    jz tia
    cincocero:
    mov a,11
    mov b,0
    pos_cursor a,b
    lea dx, cinco_cero
    jmp mission
    tia:
    mov a,11
    mov b,2
    pos_cursor a,b
    lea dx, tia_destiny
    mission:
    mov ah, 09h       
    int 21h
    delay 40
    
    call erase
    call team_players
    delay 20


    call erase
    mov a,11
    mov b,9
    pos_cursor a,b
    lea dx, press_key 
    mov ah, 09h       
    int 21h
    
    call press_key_follow
    call erase


    call arco
    mov j,68
    mov i,165
    player i,j,01h,1
    mov j,120
    circle i,j,6,0fh
    
    
    
    ;FIN------------------------------------------------------------------------------------------------------------
    jmp fin


fin: 
mov ah,07h
int 21h
mov ah,4ch
int 21h       
main endp 

;erase--------------------------------------------------------------------------------------------------------
erase proc far
    mov ah,0fh
    int 10h
    mov ah,0
    int 10h
    ret
erase endp
;--------------------------------------------------------------------------------------------------------------

;press_key_follow----------------------------------------------------------------------------------------------
press_key_follow proc far
    mov ah,07h
    int 21h
    ret
press_key_follow endp
;--------------------------------------------------------------------------------------------------------------

;team_players--------------------------------------------------------------------------------------------------
team_players proc far
    init_team_choose:
    mov a,2h
    mov b,10
    pos_cursor a,b
    lea dx, choose_your_kickers 
    mov ah, 09h       
    int 21h
    mov a,4h
    mov b,8
    pos_cursor a,b
    lea dx, choose_your_kickers_inst
    mov ah, 09h       
    int 21h 
    mov d,0h
    mov x,0h
    cmp team,1h
    jnz coq
    idol:
    mov j,0eh
    lea di,idolosh_team
    jmp choose_players
    coq:
    mov j,09h
    lea di,coquetash_team
    choose_players:
    
    mov a,11
    mov b,16
    write_player:
    pos_cursor a,b
    mov ah,0ah
    mov bx,j
    mov cx,1h
    mov al,[di]
    int 10h
    inc b
    inc di
    mov ch,[di]
    cmp ch,44
    jnz write_player
    select:
    mov a,14
    mov b,18
    pos_cursor a,b
    mov ah,1
    int 21h
    cmp al,115
    jz store_player
    cmp al,100
    jz select_end
    jmp select
    store_player:
    mov ax,si
    mov si,x
    mov kickers[si],ax
    mov si,ax
    inc x
    cmp x,5h
    jz end_team_players
    select_end:
    delay 10
    call erase
    delay 3h

    inc di
    inc d
    cmp d,0bh
    jnz choose_players
    cmp x,5h
    jz end_team_players
    mov a,11
    mov b,3
    pos_cursor a,b
    lea dx, missing_kickers
    mov ah, 09h       
    int 21h
    delay 20
    call erase
    jmp init_team_choose
    end_team_players:
    ret
team_players endp
;--------------------------------------------------------------------------------------------------------------

;ARCO----------------------------------------------------------------------------------------------------------
arco proc far    
    mov i,110
    mov j,50  
    line_hor 110,i,j,0fh
    line_vert 40,i,j,0fh
    mov i,110
    mov j,50
    line_vert 40,i,j,0fh
    ret
arco endp
;---------------------------------------------------------------------------------------------------------------

end main
