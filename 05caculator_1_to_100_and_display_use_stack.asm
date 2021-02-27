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
    ;使用栈来存储和取出数位
    mov bx,10
    xor cx,cx
    mov ss,cx
    mov sp,cx
resolver_num:
    xor dx,dx
    div bx
    add dl,0x30 ;转化为字符数字
    push dx
    inc cx ;每次分解数位的次数会累计在cx中，作为显示数位循环的次数
    cmp ax,0
    jne resolver_num 
    ;寄存器汇总存储的5050是使用16进制13ba存储，每次分解掉一次数位，直至ax
    ;寄存器中全部变为0则停止分解
    
show_num:
    pop dx
    mov [es:di],dl
    inc di
    mov byte [es:di],0x07
    inc di
    loop show_num

    jmp $

buffer times 510-($-$$) db 0
    db 0x55,0xaa

