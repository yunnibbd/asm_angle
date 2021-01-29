    jmp start
data1 db -1
data2 dw -25
start:
    mov dx,0x01
    mov ax,0
    ;sub的两个操作数不能同时为内存地址
    sub ax,dx 
    ;neg是用0减去后面制定的内容再返回这个容器中
    neg dx;
    
    times 510-($-$$) db 0
db 0x55,0xaa
