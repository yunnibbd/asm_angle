;数据串传送 原始位置是DS:SI 目标位置是ES:DI
;传送方向：
    ;正向传送：原始地址和目标地址都是从低地址到高地址推进
    ;反向传送：原始地址和目标地址都是从高地址到低地址推送
;在bochs虚拟机中查看标志寄存器信息: info eflags\rflags\flags
    ;显示的是各个标志寄存器的名字,大写表示值为1,小写表示值为0
;在8086处理器上,如果要使用寄存器来提供偏移地址,只能使用BX,SI,DI,BP,不能使用其它寄存器
;在8086处理器上,只允许以下集中基址变址的组合:
    ;bx+si bx+di bp+si bp+di
;flag的第7位是SF,它记录相关指令后,其结果是否为负,如果为负,sf=1,,否则为0
;jns指令:
    ;jns指令为不为负就跳转,也就是最近一次运算的结果的最高位是否为1,可以根据标志sf寄存器来判断是否跳转
    jmp start

text db 'y',0x07, 'u',0x07, 'n',0x07, 'n',0x07, 'i',0x07
    db 'b',0x07, 'b',0x07, 'd',0x07

start:
    mov ax,0x7c0 ;设置数据段基地址
                ;为什么是7c0不是7c00,因为这里是设置的段,具体地址是段*e+偏移地址
    mov ds,ax

    mov ax,0xb800 ;设置附加段基地址
    mov es,ax

    cld ;清0方向位,表示为正向传送
        ;std为置1方向位,表示为反向传送
    mov si,text
    mov di,0

    mov cx,(start-text)/2 ;数据的长度的一半(一半数据，一半数据格式)
    rep movsw ;字传送指令 req代表重复执行,重复的次数由cx内的值来决定
    
    mov ax,number
    ;分解各个数位
    mov bx,ax
    mov cx,5 ;循环次数
    mov si,10 ;除数

digist:
    xor dx,dx
    div si
    mov [bx],dl ;保存数位
    inc bx ;将bx内的值加1,这里是偏移到后一个数据内存地址处
    loop digist ;在cx为0前会一直跳转到digist处执行,每次执行减1

    ;开始显示各个数位
    mov bx,number
    mov si,4
show:
    mov al,[bx+si] ;将number的最后一个地址的内容
    add al,0x30
    mov ah,0x04 ;设置颜色编码
    ;由于前面设置的是正向从低到高地址传输,故ax低字节存字符,高字节存颜色
    mov [es:di],ax
    add di,2 ;加2以指向下一个显存的位置
    dec si ;让下一次bx+si指向前一个存储数位的地址
    jns show

    jmp $ ;表示重复跳转到自身

number db 0,0,0,0,0

    times 510-($-$$) db 0 ;$表示这一行的汇编地址 $$表示当前程序段的地址,这里是jmp第一行的开头的汇编地址

    db 0x55,0xaa
