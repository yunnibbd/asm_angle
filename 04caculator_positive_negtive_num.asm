;统计data1和data2里的正负数数量，ax放正数数量，dx放负数数量
    jmp start
data1 db 0x05, 0xff, 0x80, 0xf0, 0x97, 0x30
data2 dw 0x90, 0xfff0, 0xa0, 0x1235, 0x2f, 0xc0, 0xc5bc
start:
    ;设置段数据基地址
    mov ax,0x7c0
    mov ds,ax

    ;正负数清零
    xor ax,ax
    xor dx,dx

    ;设置循环次数
    mov cx,data2-data1
    mov bx,data1
cntl:
    cmp byte [bx],0x80
    jae inc_neg
    
    inc ax
    jmp pos1
inc_neg:
    inc dx

pos1:
    inc bx
    loop cntl

    ;开始比较data2
    mov cx,(start-data2)/2
    mov bx,data2

cntl2:
    ;cmp word [bx],0x8000
    cmp word [bx],0 ;按照有符号数的方式来比较
    ;jae inc_neg2
    jl inc_neg2 ;小于0跳转
    inc ax
    jmp pos2
inc_neg2:
    inc dx
pos2:
    inc bx
    loop cntl2

    jmp $

    times 510-($-$$) db 0
    db 0x55,0xaa
