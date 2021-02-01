## 寄存器BX在设计之初的作用之一就是用来提供数据访问的基地址，所以又叫基址寄存器(Base Address Register)

## 在设计8086处理器时，每个寄存器都有自己的特殊用途，比如AX是累加器(Accmulator)，与它有关的指令还会做指令长度上的优化(较短)，CX是计数器(Counter)，DX是数据(Data)寄存器，除了作为通用寄存器外，还专门用于和外设之间进行数据传送；SI是源索引寄存器(Source Index)；DI是目标索引寄存器(Destination Index)，用于数据传送操作，我们已经在movsb和movsw指令的用法中领略过了

## 计算机正负数
1. 可以说大多数指令既适用无符号整数，也适用有符号整数。指令执行的结果不管是用无符号整数还是用有符号整数来解释，都是正确的
2. 但是，也有一些指令不能同时应对无符号数和有符号数，需要根据你的实际情况，选择它们的有无符号版本。比如，无符号数乘法指令mul和有符号数乘法指令imul，以及无符号数除法指令div和有符号数乘法指令idiv

### 除法div和idiv
## 8086的8位除法和16位除法
1. 如果在指令中制定的是8位寄存器或者8位操作数的内存地址，则意味着被除数在寄存器AX里；相除后，商在寄存器AL里，余数在寄存器AH里。
2. 如果在指令中指定的是16位寄存器或者16位操作数的内存地址，则意味着被除数是32位的，低16位在寄存器AX里，高16位在寄存器DX里；相除后，商在寄存器AX里，余数在寄存器DX里。

## 32位除法，8086不支持，从80386开始支持
- 如果在指令中制定的是32位寄存器或者32位内存地址，则意味着被除数是64位的，低32位在寄存器EAX里，高32位在寄存器EDX里；相除后，商在寄存器EAX里，余数在寄存器EDX里。


    ```asm
    idiv ebx
    idiv dword [0x2002]
    ```


## 64位除法，8086不支持，从80386开始支持
- 如果在指令中指定的是64位寄存器或者64位操作数的内存地址，则意味着被除数是128位的，低64位在寄存器RAX里，高64位在寄存器RDX里；相除后，商在寄存器RAX里，余数在寄存器RDX里。


    ```asm
    idiv rbx
    idiv qword [0x2002]
    ```

- 如果被除数和除数的符号相同，商为整数，否则商为负数
- 余数的符号始终和被除数相同


### 有符号数的符号扩展指令
1. cbw convert byte to word 将AL中的有符号数扩展到AX，若AL=Fd(-3)，则扩展后，AX=FFFD(-1)
2. cwde convert word to extended double 将AX中的有符号数扩展到EAX，若AX=FFFD(-1)，则扩展后，EAX=FFFF FFFD(-3)
3. cdqe convert double_word to quad 将EAX中的有符号数扩展到RAX，若EAX=FFFF FFFD(-3)，则扩展后，RAX=FFFFFFFF FFFFFFFD(-3)
4. cwd convert word to double_wrod  将AX中的有符号数扩展到DX:AX，若AX=FFFD(-3)，则扩展后，DX=FFFF，AX=FFFD
5. cdq convert double_word to quad 将EAX中的有符号数扩展到EDX:EAX，若EAX=FFFFFFFD(-3)，则扩展后，EDX=FFFF FFFF，EAX=FFFF FFFD
6. cdo 将RAX中的有符号数扩展到RDX:RAX，若RAX=FFFFFFFF FFFFFFFD，则扩展后，RDX=FFFF FFFF，RDX=FFFF FFFD 
7. 以下是一个cwd的小栗子


    ```asm
    mov ax,-6002
    cwd
    mov bx,-10
    idiv bx
    times 510-($-$$) db 0
    db 0x55,0xaa
    ```
