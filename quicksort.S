#include <mips/regdef.h>
.text
.globl qsortMIPS
.ent qsortMIPS
# void qsortMIPS(char** izq, char** der, int num);
# 	a0  ->  izq
# 	a1  ->  der
# 	a2  ->  num

qsortMIPS:
	.frame $fp, 32, ra
	subu sp, sp, 32     #Creo el Stack Frame
	sw ra, 28(sp)    #Guardo el Return Address
	sw $fp, 24(sp)
	sw gp, 20(sp)
	move $fp, sp        #uso fp en vez de sp

	#bloque para codigo PIC
	.set noreorder
	.cpload t9
	.set reorder

	#Cargo los args en el stack
    sw a0, 32($fp) # izq
    sw a1, 36($fp) # der
    sw a2, 40($fp) # num

    lw a0, 32($fp)
    lw a1, 36($fp)

    lw t1, 32($fp) # left
    lw t2, 36($fp) # right

swap:
    lw t1, 0(a0) # &lines[0] // left
    lw t2, 0(a1) # &lines[end] // right
    
    lb t3, 0(t1) # lines[0]
    lb t4, 0(t2) # lines[end]

    addu t3, t3, 3
    addu t4, t4, 3

    sb t3, 0(t1)
    sb t4, 0(t2)

    sw t2, 0(a0)
    sw t1, 0(a1)

_exit:
	#Desarmo el Stack Frame

	move sp,$fp
	lw ra,28(sp)
	lw $fp,24(sp)
	lw gp,20(sp) 
	lw s0,(sp)
	addu sp,sp,32
	j ra

.end qsortMIPS

