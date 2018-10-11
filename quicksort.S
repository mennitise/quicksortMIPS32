#include <mips/regdef.h>

#define SS 40
#define O_RA 32
#define O_FP 28
#define O_GP 24

#define ARG_0 40
#define ARG_1 44
#define ARG_2 48

#define O_LEFT 16
#define O_RIGHT 20

.text
.align 2
.globl qsortMIPS
.ent qsortMIPS
# void qsortMIPS(char** left, char** right, int numeric);
# 	a0  ->  left
# 	a1  ->  right
# 	a2  ->  numeric

# STACK
# 
	#	 +--------------+
	# 40 |//////////////|
	#	 +--------------+
	# 32 |		ra 		|
	#	 +--------------+
	# 28 |		fp 		|
	#	 +--------------+
	# 24 |		gp 		|
	#	 +--------------+
	# 20 |	   right 	|
	#	 +--------------+
	# 16 |	   left		|
	#	 +--------------+
	# 12 |//////////////|
	#	 +--------------+
	# 8	 |		a2 		|
	#	 +--------------+
	# 4	 |		a1 		|
	#	 +--------------+
	# 0	 |		a0 		|
	#	 +--------------+


qsortMIPS:
	.set noreorder
	.cpload t9
	.set reorder

	subu sp, sp, SS     #Creo el Stack Frame
	sw ra, O_RA(sp)    #Guardo el Return Address
	sw $fp, O_FP(sp)
	sw gp, O_GP(sp)

	#Cargo los args en el stack
	sw a0, ARG_0(sp) # left
	sw a1, ARG_1(sp) # right
	sw a2, ARG_2(sp) # numeric

	lw a0, ARG_0(sp)
	lw a1, ARG_1(sp)

	lw t1, ARG_0(sp) # t1 = limit_left
	lw t2, ARG_1(sp) # t2 = limit_right


	lw t6, ARG_0(sp) # t6 = left
	lw t7, ARG_1(sp) # t7 = right


	b _exit


	# PIVOT - t3 = pivot
	srl t8, t6, 2
	srl t9, t7, 2
	addu t3, t8, t9
	srl t3, t3, 1
	sll t3, t3, 2

while_loop:
	bgtu t6, t7, end_while_loop # left > right
	lb t8, 0(t3) # t8 = *pivot

# while ((compare(list[left], pivot) < 0) && (left < limit_right)) left++;
while_left_loop:
	lb t4, 0(t6) # t4 = *left
	bgeu t4, t8, while_right_loop # ???? - branch strcmp(*left, *pivot) < 0, while_right_loop
	bgeu t6, t2, while_right_loop # branch (left >= limit_right), while_right_loop
	addu t6, t6, 4 # left++
	b while_left_loop

# while ((compare(pivot, list[right]) < 0) && (right > limit_left)) right--;
while_right_loop:
	lb t5, 0(t7) # t5 = *right
	bgeu t8, t5, end_while_left_right_loop # ???? - branch compare->(t8 >= t5), end_while_left_right_loop
	bleu t7, t1, end_while_left_right_loop # branch (right <= limit_left), end_while_left_right_loop
	subu t7, t7, 4 # right--
	b while_right_loop


end_while_left_right_loop:
	bgtu t6, t7, while_loop # left > right
	lw t1, 0(t6) 
    lw t2, 0(t7)
    sw t2, 0(t6) # swap left <-> right
    sw t1, 0(t7)
	addu t6, t6, 4 # left++
	subu t7, t7, 4 # right--
	b while_loop

end_while_loop:
	sw t6, O_LEFT(sp)
	sw t7, O_RIGHT(sp)

qsort_left:
	bgeu t1, t7, qsort_right # limit_left >= right
	lw a0, ARG_0(sp) # a0 - limit_left
	move a1, t7 # a1 - right
	la t9, qsortMIPS
	jal t9
	lw a0, ARG_0(sp)
	lw a1, ARG_1(sp)

qsort_right:
	bleu t2, t6, _exit # limit_right <= left
	move a0, t6 # a0 - left
	lw a1, ARG_1(sp) # a1 - limit_right
	la t9, qsortMIPS
	jal t9
	lw a0, ARG_0(sp)
	lw a1, ARG_1(sp)

_exit:
	#Desarmo el Stack Frame
	lw ra, O_RA(sp)
	lw $fp, O_FP(sp)
	lw gp, O_GP(sp) 
	lw s0, (sp)
	addu sp, sp, SS
	j ra

.end qsortMIPS

