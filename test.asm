xor ax,ax
mov cx,4
delay:
    inc ax
    loop delay

    jmp $
    times 510-($-$$) db 0

db 0x55,0xaa
