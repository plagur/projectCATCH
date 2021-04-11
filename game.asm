.model small
.stack 100h
.data
si_bsk_2 dw 0
si_bsk dw 160*24+72
ball_start_pos dw 160*24+120,160*24+16,160*24+78,160*24+54,160*24+36,160*24+98,160*24+12,160*24+2,160*24+144,160*24+64,160*24+86,160*24+160,160*24+74,160*24+110,160*24+142,160*24+24,160*24+98,160*24+68,160*24+58,160*24+14,160*24+68,160*24+158,160*24+8,160*24+26,160*24+118 ;ball position when drops
;ball_pos_index dw 0
si_save_ball dw 0
color db 44h,55h,55h,55h,55h,55h,44h,44h,55h,44h,44h,55h,55h,55h,44h,55h,55h,55h,55h,55h,44h,55h,44h,44h ;used to determine what color the ball will be
count_frames dw 24; counts the frames while the ball falls
count_level dw 25 ;counts the remaining levels
color_index dw 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24 ;indexes the color
count db 0
fail_check db 0
count_frame db 0
.code

game proc;the actual integration of all the parts of the game
call basketchar 

floop:
mov ah,1
int 16h
jz movement
mov ah,0
int 16h
call basket
jmp floop
movement:
call ball_frame
dec count_frames    
mov cx,count_frames
jmp floop
;mov si,si_save_ball
;cmp si,si_bsk
;jb nok
;cmp si,si_bsk2
;ja nok2
;inc count
;mov fail_check,1
;Mov 
;nok:
;nok2:
;cmp fail_check,1
;je aok
;call enter_screen
;aok:
inc di

ret
game endp

delay proc ;
MOV     CX, 1b
MOV     DX,0999H
MOV     AH, 86H
INT     15H
ret 
delay endp

ball_frame proc
cmp count_frame,24
jne frame
mov di,color_index
inc color_index
;mov bp,ball_pos_index
mov bx,ball_start_pos[di]
mov si_save_ball,bx
mov cx,24
mov ah,color[di]
frame:
call delay
mov si,si_save_ball
mov dh,0BBH
mov dl,""
mov es:[si],dx
add si_save_ball,160
mov si,si_save_ball
mov dh,color[di]
mov dl,""
mov es:[si],dx
inc count_frame
ret
ball_frame endp


ver_line proc ;legit wat is says
    mov cx,4
    next:
    sub si,160
         mov es:[si],ax
         loop next
ret 
ver_line endp

hor_line proc ;legit wat is says
    mov cx,7
    nextt:
         add si,2
         mov es:[si],ax
         loop nextt
ret 
hor_line endp
basketchar proc ;legit wat is says
mov ah,01100110b
mov si,si_bsk
call hor_line
sub si,12
call ver_line
add si,4*160+12
call ver_line



ret 
basketchar endp
basketdel proc ;delets the char to make it "mov'
mov si,si_bsk
mov ah,33h
call hor_line
sub si,12
call ver_line
add si,4*160+12
call ver_line
mov bx,6-160*3

ret 
basketdel endp
cls proc
mov cx,25*80
mov si,0
mov al, " "
mov ah,0bbH
loooop:
    mov es:[si],ax
    add si,2
    loop loooop 
    mov ah,33h

ret
cls endp
basketmov_l proc ;legit wat is says,moves the basket one pixel left
call basketdel
sub si_bsk,2
cmp si_bsk,23*160+156
ja below
add si_bsk,2
below:
call basketchar
ret
basketmov_l endp

basketmov_r proc ;legit wat is says,same but to the right
call basketdel
add si_bsk,2
mov dx,14 ;not sure what it does but it is needed for the basket to move right
mov bx,si_bsk
mov si_bsk_2,bx
add si_bsk_2,dx
cmp si_bsk_2,25*160
jb above
sub si_bsk,2
above:
call basketchar

ret
basketmov_r endp
basket proc ;the whole basket, lol
    cmp ah,4bh
    jne notleft
    call basketmov_l
    notleft:
    cmp ah,4dh
    jne notright
    call basketmov_r
    notright:
   
ret
basket endp
 start:
    mov ax,@data
    mov ds,ax
    ;***********************************
    mov ax,0b800h
    mov es,ax
    mov al,""
    call cls
    ;call lopball
    call game
    ;***********************************
    mov ah,4ch
    int 21H
end start
