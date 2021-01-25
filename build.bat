if exist LEARN.vhd.lock del LEARN.vhd.lock
nasm test.asm -o out.bin
nasm test.asm -l out.lst
