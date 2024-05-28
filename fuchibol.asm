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
    inst_center db "W: Centro$"
    inst_right db "D: Derecha$"
    inst_left db "A: Izquierda$"
    goal_msg db "GOOOOL$"
    fail_msg db "NOOOOOO$"
    bsc_name db "IDO$"
    cse_name db "COQ$"
    kickers dw 5 dup(0)
    buffer db 2 dup("$")
    init_green db 0ah
    num_pentaltys db 5
    my_score db 0
    computer_score db 0
    pos db 165
    pos_ball db 165
    


    team db ?
    computer_team db ?
    color db ?
    x dw ?
    y dw ?
    i dw ?
    j dw ?
    a db ? 
    b db ?
    d db ?
    e db ?
    f dw ?
    

.code
main proc
    mov ax, @data
    mov ds, ax
    
    call erase
    
    mov ax,013h 
    int 10h
    delay 10
    
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
    delay 2
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
    delay 2
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
    mov computer_team,2
    jz choosen
    cmp al,32h
    mov computer_team,1
    jz choosen
    jmp choose
    choosen:
    call input_sound
    sub al,30h
    mov team,al

    delay 5
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
    delay 10
    
    call erase
    mov a,5
    mov b,15
    pos_cursor a,b
    lea dx, inst_center
    mov ah, 09h       
    int 21h
    add a,4
    pos_cursor a,b
    lea dx, inst_right
    mov ah, 09h       
    int 21h
    add a,4
    pos_cursor a,b
    lea dx, inst_left
    mov ah, 09h       
    int 21h
    delay 40

    call erase
    mov a,11
    mov b,9
    pos_cursor a,b
    lea dx, press_key 
    mov ah, 09h       
    int 21h
    
    call press_key_follow
    call erase
;---------------------------------------------------------------------------------------------------------------------
    mov ax, 0600h   
    MOV bh, 02h  
    mov ch, [init_green]
    mov cl, 0
    mov dh, 24  
    mov dl, 39
    INT 10H  
    
    

    call arco
    mov i,165
    push i
    mov j,66
    player i,j,computer_team,1
    mov j,170
    circle i,j,6,0fh
    sub i,10
    add j,10
    player i,j,team,0
    
    call score_board

    movement:
    delay 1
    mov ah,01h
    int 16h
    jnz fin
    call delete_goalKeeper
    mov i,165
    mov j,66
    mov pos,165
    player i,j,computer_team,1
    delay 3
    mov ah,01h
    int 16h
    jnz fin
    call delete_goalKeeper
    mov i,195
    mov j,66
    mov pos,195
    player i,j,computer_team,1
    delay 3
    mov ah,01h
    int 16h
    jnz fin
    call delete_goalKeeper
    mov i,165
    mov j,66
    mov pos,165
    player i,j,computer_team,1
    delay 3
    mov ah,01h
    int 16h
    jnz fin
    call delete_goalKeeper
    mov i,135
    mov j,66
    mov pos,135
    player i,j,computer_team,1
    jmp movement


    
    
    
    
;FIN------------------------------------------------------------------------------------------------------------------
    jmp fin


    fin: 
    call your_goal
    call score_board
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
    call input_sound 
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
    call input_sound
    inc x
    cmp x,5h
    jz end_team_players
    select_end:
    delay 3
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
    delay 10
    call erase
    jmp init_team_choose
    end_team_players:
    ret
team_players endp
;--------------------------------------------------------------------------------------------------------------

;ARCO----------------------------------------------------------------------------------------------------------
arco proc far    
    mov i,110
    mov j,47  
    line_hor 110,i,j,0fh
    line_vert 40,i,j,0fh
    mov i,110
    mov j,47
    line_vert 40,i,j,0fh
    mov i,0
    line_hor 200,i,j,0fh
    line_hor 120,i,j,0fh
    mov i,40
    line_vert 112,i,j,0fh
    mov i,290
    sub j,112
    line_vert 112,i,j,0fh
    ret
arco endp
;---------------------------------------------------------------------------------------------------------------

;delete_goalKeeper----------------------------------------------------------------------------------------------
delete_goalKeeper proc far
    mov ax, 0600h   
    mov bh, 0h  
    mov ch, [init_green]
    sub ch, 3
    mov cl, 0
    mov dh, [init_green]  
    mov dl, 39
    int 10h 
    mov j,140  
    mov bh, 02h  
    mov ch, [init_green]
    mov cl, 0
    mov dh, [init_green]
    add dh,1  
    mov dl, 39; DH=fila, DL=columna
    int 10h 
    call arco
    ret
delete_goalKeeper endp
;---------------------------------------------------------------------------------------------------------------

your_goal proc 
    mov pos_ball,al
    mov ax, 0600h   
    mov bh, 0h  
    mov ch, 18
    mov cl, 16
    mov dh, 24
    mov dl, 20
    int 10h  
    mov bh, 02h   
    int 10h
    mov i,160
    mov j,170
    square i,j,3,0fh
    sub i,5
    player i,j,team,0
    mov j,64
    cmp pos_ball,115
    jnz no_center
    mov i,165
    jmp new_pos_ball
    no_center:
    cmp pos_ball,100
    jnz no_right
    mov i,195
    jmp new_pos_ball
    no_right:
    mov i,135
    
    new_pos_ball:
    mov ax,i
    mov pos_ball,al
    add j,10
    circle i,j,6,0fh
    mov al, pos_ball
    cmp al,pos
    jnz goal
    mov a,2
    mov b,15
    pos_cursor a,b
    lea dx, [fail_msg]   
    mov ah, 09h    
    int 21h
    jmp fin_goal
    goal:
    mov a,2
    mov b,177
    pos_cursor a,b
    lea dx, goal_msg    
    mov ah, 09h    
    int 21h 
    inc my_score
    fin_goal:
    delay 20
    ret
your_goal endp


;---------------------------------------------------------------------------------------------------------------------

score_board proc
    mov ax, 0600h   
    mov bh, 0h  
    mov ch, 1
    mov cl, 0
    mov dh, 1
    mov dl, 39
    int 10h 


    mov a,1
    mov b,0
    pos_cursor a,b
    lea dx, [bsc_name]    
    mov ah, 09h    
    int 21h 

    add b,4
    pos_cursor a,b
    mov al,[my_score]
    add al,'0'
    mov [buffer],al 
    mov dx, offset buffer
    int 21h
    
    add b,2
    pos_cursor a,b
    lea dx, [cse_name]  
    int 21h

    add b,4
    pos_cursor a,b
    mov al,[computer_score]
    add al,'0'
    mov [buffer],al 
    mov dx, offset buffer
    int 21h


    ret
score_board endp

input_sound proc far
    push ax
    push bx
	mov al, 3       
	mov bx, 4000h   
	mov CX, 1 
	
    input_loop_sound:
	out 43h, al     
	mov ax, bx
	out 42h, al     
	mov al, ah
	out 42h, al     
	
	mov ax, 40h
	mov al, 3       
	out 61h, al
	
	mov ax, 86DDh   
	INT 15h
	
	mov ax, 40h
	mov al, 0       
	out 61h, al
	
    dec cx
	jnz input_loop_sound   
	
	pop bx          
	pop ax
	ret
input_sound endp


end main
