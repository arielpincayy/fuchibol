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
    winner db "Has ganado :D$"
    looser db "Ni para patear un penal :C$"
    idol_winner db "El TIA te lo agradecera por siempre$"
    idol_looser db "El TIA sufrio las consecucnecias$"
    coq_winner db "Has conseguido vengar el cincocero$"
    coq_looser db "Ya nada, hay que saquear el TUTI$"
    
    idolosh_team db "Burrai,Vargas,Rodriguez,Sosa,Chala,Souza,Trindade,Corozo,Solano,Kitu,Polaco,$"
    coquetash_team db "Ortiz,Caicedo,Leguizamon,Leon,Cortez,Cortez,Erbes,Garces,Meli,Carabali,Ruiz,Castelli,$"
    inst_center db "S: Centro$"
    inst_right db "D: Derecha$"
    inst_left db "A: Izquierda$"
    goal_msg db "GOOOOL$"
    fail_msg db "NOOOOOO$"
    bsc_name db "IDO$"
    cse_name db "COQ$"
    kickers db 5 dup(0)
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
    
    ;graphical mode setting
    mov ax,013h 
    int 10h
    delay 10

    ;write letter by letter the title
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
    delay 10
    call erase
    
    
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
    
    ;choose team
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
    
    ;show the mission
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
    
    ;game instructions
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

    ;press key to continue
    call erase
    mov a,11
    mov b,9
    pos_cursor a,b
    lea dx, press_key 
    mov ah, 09h       
    int 21h
    
    call press_key_follow
;---------------------------------------------------------------------------------------------------------------------
    
    ;penalties
    
    penalties_match:   
;your turn----------------------------------------------------------------------------------------------------------  
    ;draw the scenario
    call erase
    mov ax, 0600h   
    mov bh, 02h  
    mov ch, [init_green]
    mov cl, 0
    mov dh, 24  
    mov dl, 39
    int 10H  
    call arco
    
    ;draw goalkeeper, kicker, board, name kicker
    call score_board
    mov i,165
    push i
    mov j,66
    player i,j,computer_team,1
    mov j,170
    circle i,j,6,0fh
    sub i,10
    add j,10
    player i,j,team,0
    call name_kicker

    ;goalkeeper movement
    movement:
    delay 3
    mov ah,01h
    int 16h
    call delete_goalKeeper
    mov i,165
    mov j,66
    mov pos,165
    player i,j,computer_team,1
    delay 3
    mov ah,01h
    int 16h
    jnz shooted
    call delete_goalKeeper
    mov i,195
    mov j,66
    mov pos,195
    player i,j,computer_team,1
    delay 3
    mov ah,01h
    int 16h
    jnz shooted
    call delete_goalKeeper
    mov i,165
    mov j,66
    mov pos,165
    player i,j,computer_team,1
    delay 3
    mov ah,01h
    int 16h
    jnz shooted
    call delete_goalKeeper
    mov i,135
    mov j,66
    mov pos,135
    player i,j,computer_team,1
    jmp movement
    
    ;kick checker
    shooted:
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

    mov f,0
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
    call is_goal
    call score_board

    ;you win?
    mov al,[num_pentaltys]
    add al,[computer_score]
    cmp al,[my_score]
    jl fin
    
    mov al,[num_pentaltys]
    dec al
    add al,[my_score]
    cmp al,[computer_score]
    jl fin

    delay 5
;-----------------------------------------------------------------------------------------------------------------    
    
;computer turn----------------------------------------------------------------------------------------------------   
    ;draw the scenario
    call press_key_follow
    call erase
    mov ax, 0600h   
    MOV bh, 02h  
    mov ch, [init_green]
    mov cl, 0
    mov dh, 24  
    mov dl, 39
    int 10H  
    call arco

    ;draw goalkeeper, kicker, board, name kicker
    call score_board
    mov i,165
    push i
    mov j,66
    player i,j,team,1
    mov j,170
    circle i,j,6,0fh
    sub i,10
    add j,10
    player i,j,computer_team,0

    ;ball direction
    movement2:
    delay 3
    mov ah,01h
    int 16h
    mov i,165
    mov [pos_ball],165
    delay 3
    mov ah,01h
    int 16h
    jnz shooted2
    mov i,195
    mov [pos_ball],195
    delay 3
    mov ah,01h
    int 16h
    jnz shooted2
    mov i,165
    mov [pos_ball],165
    delay 3
    mov ah,01h
    int 16h
    jnz shooted2
    mov i,135
    mov [pos_ball],135
    jmp movement2
    
    ;kick checker
    shooted2:
    mov pos,al
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
    player i,j,computer_team,0
    mov f,1

    cmp pos,115
    jnz no_center2
    mov i,165
    jmp new_pos_ball2
    no_center2:
    cmp pos,100
    jnz no_right2
    mov i,195
    jmp new_pos_ball2
    no_right2:
    mov i,135
    
    new_pos_ball2:
    push i
    call delete_goalKeeper
    pop bx 
    mov i,bx
    mov pos,bl
    mov j,66
    player i,j,team,1
    xor bx,bx
    mov bl,[pos_ball]
    mov i,bx
    call is_goal
    call score_board
    
    ;you loose?
    mov al,[num_pentaltys]
    add al,[my_score]
    cmp al,[computer_score]
    jl fin

    
    mov al,[num_pentaltys]
    dec al
    add al,[computer_score]
    cmp al,[my_score]
    jl fin
;-----------------------------------------------------------------------------------------------------------------
    
    call press_key_follow
    dec [num_pentaltys]   ; verifica si se acabo la tanda de penales
    cmp [num_pentaltys],0  
    jnz penalties_match

    ;tie-breaker
    mov [num_pentaltys],1 ; verifica si la tanda termino en un empate
    xor ax,ax             ; en dicho caso, se agrega un penal mas para cada equipo hasta que desempaten
    mov al,[my_score]
    cmp al,[computer_score]
    jz penalties_match
   
;FIN------------------------------------------------------------------------------------------------------------------

    fin:
    call erase
    mov bl,[my_score]
    cmp bl,[computer_score]
    jl loose_match
    
    mov a,8
    mov b,12
    pos_cursor a,b
    lea dx, winner 
    mov ah, 09h       
    int 21h
    mov bl,[team]
    cmp bl,1
    jz idol_w
    
    mov a,12
    mov b,2
    pos_cursor a,b
    lea dx, [coq_winner] 
    mov ah, 09h       
    int 21h
    jmp winner_match

    idol_w:
    mov a,12
    mov b,2
    pos_cursor a,b
    lea dx, [idol_winner] 
    mov ah, 09h       
    int 21h
    jmp winner_match 

    loose_match:
    mov a,8
    mov b,5
    pos_cursor a,b
    lea dx, looser 
    mov ah, 09h       
    int 21h
    mov bl,[team]
    cmp bl,1
    jz idol_l
    
    mov a,12
    mov b,5
    pos_cursor a,b
    lea dx, [coq_looser] 
    mov ah, 09h       
    int 21h
    jmp winner_match
    
    idol_l:
    mov a,12
    mov b,5
    pos_cursor a,b
    lea dx, [idol_looser] 
    mov ah, 09h       
    int 21h

    winner_match:
    delay 20
    call press_key_follow
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
    cmp team,1
    jnz coq
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


    mov ax,di
    mov di,x
    push bx
    mov bl,d
    mov kickers[di],bl
    mov di,ax
    pop bx


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

;Draw goal----------------------------------------------------------------------------------------------------------
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
    inc dh 
    mov dl, 39; DH=fila, DL=columna
    int 10h 
    call arco
    ret
delete_goalKeeper endp
;---------------------------------------------------------------------------------------------------------------------

;verify goal----------------------------------------------------------------------------------------------------------
is_goal proc far
    push f
    mov j,64
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
    lea dx, fail_msg  
    mov ah, 09h    
    int 21h
    pop bx
    delay 20
    ret
    goal:
    mov a,2
    mov b,177
    pos_cursor a,b
    lea dx, goal_msg    
    mov ah, 09h    
    int 21h 
    pop bx
    cmp bx,0
    jz my_goal
    inc computer_score
    delay 20
    ret
    my_goal:
    inc my_score
    delay 20
    ret
is_goal endp
;---------------------------------------------------------------------------------------------------------------------

;score board----------------------------------------------------------------------------------------------------------
score_board proc far
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
;---------------------------------------------------------------------------------------------------------------------

;key sound------------------------------------------------------------------------------------------------------------
input_sound proc far
    push ax
    push bx
	mov al, 3h    ; Carga el valor 3h en el registro AL, configurando el modo del temporizador.   
	mov bx, 4000h ; Carga el valor 4000h en el registro BX, que representa el divisor para el temporizador. 
	
	out 43h, al   ; Envia el valor de AL al puerto 43h (control del temporizador 8253)
	mov ax, bx
	out 42h, al   ; Envia el valor de AL al puerto 42h (canal 2 del temporizador 8253)  
	mov al, ah
	out 42h, al   ; Envia el valor de AL al puerto 61h (control del altavoz del sistema)  
	mov al, 3       
	out 61h, al   ; Envia el valor de AL al puerto 61h (control del altavoz del sistema)
	mov cx, 1h
	mov ax, 86DDh    
	int 15h       ; Llamar a la interrupción 15h para esperar un tiempo
	mov ax, 40h
	mov al, 0       
	out 61h, al   ; Envia el valor de AL al puerto 61h (apaga el altavoz del sistema)

	pop bx          
	pop ax
	ret
input_sound endp
;---------------------------------------------------------------------------------------------------------------------

;name kicker----------------------------------------------------------------------------------------------------------
name_kicker proc far
    push cx
    push ax
    push di
    push bx
    mov a,1
    mov b,18

    mov bx,5
    sub bl,num_pentaltys
    mov di,bx
    
    pos_cursor a,b
    mov al, [kickers + di]
    mov bl,al
    
    cmp team,1
    jz idolosh_kickers
    lea di,[coquetash_team]
    mov ch,09h
    mov e,ch
    jmp find_kicker
    idolosh_kickers:
    mov ch,0eh
    mov e,ch
    lea di,[idolosh_team]
    
    find_kicker:
    mov al,[di]
    cmp bl,0
    jz write_kicker
    cmp al,44
    jnz next_letter_kickers
    dec bl
    next_letter_kickers:
    inc di
    jmp find_kicker
    
    write_kicker:
    mov ch,[di]
    cmp ch,44
    jz end_write_kicker
    pos_cursor a,b
    mov ah,0ah
    mov al,[di]
    mov bx,0
    mov bl,e
    mov cx,1
    int 10h
    inc di
    inc b
    jmp write_kicker
    
    
    end_write_kicker:

    pop bx
    pop di
    pop ax
    pop cx
    ret
name_kicker endp
;---------------------------------------------------------------------------------------------------------------------


end main
