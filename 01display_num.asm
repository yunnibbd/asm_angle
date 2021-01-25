start:
    mov ax,65535
    xor dx,dx
    mov bx,10
    div bx
    add dl,0x30 ;数字5
    mov cx,0
    mov ds,cx    
    mov [0x7c00+buffer],dl

    xor dx,dx
    div bx
    add dl,0x30 ;数字3
    mov [0x7c00+buffer+1],dl

    xor dx,dx
    div bx
    add dl,0x30 ;数字5
    mov [0x7c00+buffer+2],dl

    xor dx,dx
    div bx
    add dl,0x30 ;数字5
    mov [0x7c00+buffer+3],dl

    add al,0x30 ;数字6
    mov [0x7c00+buffer+4],al

    mov al,[0x7c00+buffer+4]
    mov cx,0xb800
    mov es,cx ;将显存地址存储到附加段寄存器es中

    mov [es:0x00],al
    mov byte [es:0x01],0x2f

    mov al,[0x7c00+buffer+3]
    mov [es:0x02],al
    mov byte [es:0x03],0x2f

    mov al,[0x7c00+buffer+2]
    mov [es:0x04],al
    mov byte [es:0x05],0x2f

    mov al,[0x7c00+buffer+1]
    mov [es:0x06],al
    mov byte [es:0x07],0x2f

    mov al,[0x7c00+buffer]
    mov [es:0x08],al
    mov byte [es:0x09],0x2f

agian:
    jmp agian

buffer db 0, 0, 0, 0, 0

current:
    times 510 - (current - start) db 0

    db 0x55, 0xaa
