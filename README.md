### 寄存器BX在设计之初的作用之一就是用来提供数据访问的基地址，所以又叫基址寄存器(Base Address Register)

### 在设计8086处理器时，每个寄存器都有自己的特殊用途，比如AX是累加器(Accmulator)，与它有关的指令还会做指令长度上的优化(较短)，CX是计数器(Counter)，DX是数据(Data)寄存器，除了作为通用寄存器外，还专门用于和外设之间进行数据传送；SI是源索引寄存器(Source Index)；DI是目标索引寄存器(Destination Index)，用于数据传送操作，我们已经在movsb和movsw指令的用法中领略过了

### 计算机正负数
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

### 8086的标志位寄存器
- 第0位，CF：进位标志(Carry Flag)，当一个算术操作在结果的最高位产生进位或者借位后，此标志为1，否则为0
- 第2位，PF：奇偶标志(Prrity Flag)，当一个算术操作的结果在低8位中有偶数个"1"，此标志位是1，否则为0
- 第4位，AF：调整标志(Adjust Flag)，当一个算术操作在结果的位3产生进位或者借位时，此标志是1，否则是0，此标志用于二进制编码的十进制数算法中
- 第6位，ZF：零标志(Zero Flag)，当运算的结果为0时，此标志为1，否则为0
- 第7位，SF：符号标志(Sign Flag)，用运算结果的最高位来设置此标志(一般来说，这是有符号数的符号位，0表示正数，1表示负数)
- 第11位，OF：溢出标志(Overflow Flag)，对任何一个算术操作，假定它进行的是有符号运算。那么，当结果超出目标位置所能容纳的最大正数或者最小负数时，此标志为1，表示有符号整数运算的结果已经溢出，否则为0

## 现有指令对标志位的影响
- cbw/cwde/cdqe/cwd/cdq/cqo 不影响任何标志位
- cld DF=0，对CF OF ZF SF AF和PF的影响未定义
- std DF=1，不影响其他标志位
- inc/dec CF标志不受影响，对OF SF ZF和PF的影响依计算结果而定
- add/sub OF SF ZF CF和PF的状态依计算结果而定
- div/idiv 对CF OF SF ZF AF和PF的影响未定义
- mov/movs 这类指令不影响任何标志位
- neg 如果操作数为0，则CF=0，否则CF=1；对OF SF ZF AF和PF的影响依计算结果而定
- xor OF=0，CF=0；对SF ZF和PF依计算结果而定，对AF的影响未定义

### 条件转移指令和CMP指令
- js 符号标志SF为1则转移
- jns 符号标志SF不为1(为0)时转移
- jz 零标志ZF为1则转移
- jnz 零标志ZF不为1(为0)时转移
- jo 移除标志OF为1则转移
- jno 溢出标志OF不为1(为0)时转移
- jc 进位标志CF为1则转移
- jnc 进位标志CF不为1(为0)则转移
- jp 奇偶标志PF为1则转移
- jnp 奇偶标志PF不为1(为0)时转移

### cmp指令栗子
- 具体看 受CMP指令执行结果影响的条件转移指令及其依赖的标志位状态.pdf
- 该指令执行后，会影响标志寄存器CF OF SF ZF AF PF


        ```
        ;比较dh和0，如果dh小于0就转移到negb
        cmp dh 0
        jl negb


        ;比较dh和0x80，如果dh大于或者等于0x80就转移到negb
        cmp dh,0x80
        ;jae:jump if above or qual
        jae negb
        ```
- jcxz(iump if CX is zero)，当CX寄存器为0时转移，例如 jcxz show 

### push的执行过程,执行完毕不影响标志寄存器
1. SP <- SP - 操作数的大小(字节数)
2. 段寄存器SS左移4位，加上SP里的偏移地址，生成物理地址
3. 将操作数写入上述地址处

### pop的执行过程
1. 段寄存器SS左移4位，加上SP里的偏移地址，生成物理地址
2. 从上述地址处取得数据，存入由操作数提供的目标位置处
3. SP <- SP + 2

### or
- 逻辑或指令or执行后，OF=0，CF=0
- SF、ZF、PF依计算结果而定
- AF的状态未定义

### 基址寻址
- 如果使用基址寄存器bx作为地址，默认使用ds作为段寄存器
- 如果使用基址寄存器bp作为地址，默认使用ss作为段寄存器

### 变址寻址
- 变址寻址是使用si和di


