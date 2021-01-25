## 寄存器BX在设计之初的作用之一就是用来提供数据访问的基地址，所以又叫基址寄存器(Base Address Register)

## 在设计8086处理器时，每个寄存器都有自己的特殊用途，比如AX是累加器(Accmulator)，与它有关的指令还会做指令长度上的优化(较短)，CX是计数器(Counter)，DX是数据(Data)寄存器，除了作为通用寄存器外，还专门用于和外设之间进行数据传送；SI是源索引寄存器(Source Index)；DI是目标索引寄存器(Destination Index)，用于数据传送操作，我们已经在movsb和movsw指令的用法中领略过了

