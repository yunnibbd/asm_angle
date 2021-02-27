    jmp start
message db "1+2+3+...+100 = "
start:
    mov ax,0x7c0
    mov ds,ax

    mov ax,0xb800
    mov es,ax

    mov si,message
    xor di,di

    mov cx,start-message
    ;显示提示信息
show_message:
    mov al,[si]
    mov [es:di],al
    inc di
    mov byte [es:di],0x07
    inc di
    inc si
    loop show_message 

    ;计算累加100
    xor ax,ax
    mov cx,1
summate:
    add ax,cx
    inc cx
    cmp cx,100
    jle summate

    ;将累加结果在屏幕上
    mov bx,10
    xor dx,dx
    mov cx,4
    mov si,buffer
resolver_num:
    xor dx,dx
    div bx
    add dl,0x30 ;转化为字符数字
    mov [si],dl
    inc si
    loop resolver_num
    
    mov cx,4
    dec si
show_num:
    mov al,[si]
    mov [es:di],al
    inc di
    mov byte [es:di],0x07
    inc di
    dec si
    loop show_num

    jmp $

buffer times 510-($-$$) db 0
    db 0x55,0xaa

