    jmp start
info db "123456789"

start:
    ;设置段数据段寄存器ds
    mov ax,0x7c0
    mov ds,ax

    ;设置栈段寄存器ss
    mov ax,cs
    mov ss,ax
    ;清零栈偏移寄存器sp
    mov sp,0

    ;设置循环次数
    mov cx,start-info
    ;使用变址寄存器si
    mov si,info
    xor ax,ax
push_stack:
    mov al,[si] 
    push ax
    inc si
    loop push_stack

    mov cx,start-info
    ;使用变址寄存器di
    mov di,info
    xor ax,ax
pop_stack:
    pop ax
    mov [di],al
    inc di
    loop pop_stack

    mov bx,0xb800
    mov es,bx
    mov si,info
    ;设置loop次数
    mov cx,start-info
    xor bx,bx
show_num:
    mov al,[si]
    mov [es:bx],al 
    inc bx
    mov byte [es:bx],0x07
    inc bx
    inc si
    loop show_num

    jmp $

    times 510-($-$$) db 0
    db 0x55,0xaa


