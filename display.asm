%macro	write_str 2
	push	eax
	push	ebx
	push	ecx
	push	edx
	mov	edx,%2
	mov	ecx,%1
	mov	ebx,1
	mov	eax,4
	int	0x80
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
%endmacro
section .bss
address resb 4
section .data
   hex_char	db	'0123456789ABCDEF'
   bMem times 8 db 0x30	;Memory to store string
   cMem		db	65
section	.text
	global	write_hex
	global	space
	global	newline
	global  write_char
	global  write_bin
	global	write_dec
	global  writestr
	global  write_hex_digit
	global  write_address
	global  write_address_value
writestr:
	push	ebp
	mov	ebp,esp
	mov	esi,[ebp+8]
	mov	ecx,[ebp+12]
	write_str  esi,ecx
	leave
	ret
space:
	mov	byte[cMem],32
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	write_str cMem,1
	ret
newline:
	mov	byte[cMem],10
	write_str cMem,1
	ret
write_char:
	mov	byte[cMem],al
	write_str cMem,1
  	ret
write_hex_digit:
	;input al
	push	eax
	push	ebx
	mov	ebx,hex_char
	xlat
	call write_char
	pop	ebx
	pop	eax
	ret
write_address:
;using eax
	push eax
	mov [address], dword eax
	mov al,[address+3]
	call write_hex
	mov al,[address+2]
	call write_hex
	mov al,[address+1]
	call write_hex
	mov al,[address]
	call write_hex
	pop eax
	ret
write_hex:
	;input  al
	push	eax
	push	ecx
	push	edx
	mov	dl,al
	mov	cl,4
	shr	al,cl
	;cmp al,0
	;je track1
	call	write_hex_digit
;track1:
	mov	al,dl
	and 	al,0x0f
	call	write_hex_digit
	pop	edx
	pop	ecx
	pop	eax
	ret

write_bin:
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	push	esi
	push	edi

	push	eax

	;---reset bMem to '00000000'
	mov	al,0x30
	mov	ecx,8
	mov	edi,bMem
	cld
	rep	stosb
	;---
	pop	eax
_st_writebin:
	mov	ecx,7
	mov	esi,bMem
	mov	bl,128
_bin_disp_loop:
	mov	dl,al
	test	dl,bl
	jz	dl_zero
	inc	byte[esi]
dl_zero:
	inc	esi
	shr	bl,1
	loop	_bin_disp_loop

	write_str  bMem,8

	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	ret
write_dec:
	;input  ax
	push	ebx
	push	ecx
	push	edx
	xor	bx,bx
	mov	ecx,10
_div_loop:
	xor	dx,dx
	div	cx
	push	edx
	inc	bx
	cmp	ax,0
	jnz    _div_loop
_div_loop_fin:
	mov	cx,bx
_print_loop:
	pop	eax
	add	al,0x30
	call	write_char
	loop	_print_loop

	pop	edx
	pop	ecx
	pop	ebx
	ret
write_address_value:
;input  ax
	push eax
	push	ebx
	push	ecx
	push	edx
	xor	ebx,ebx
	mov	ecx,10
_div_loop1:
	xor	edx,edx
	div	ecx
	push	edx
	inc	bx
	cmp	eax,0
	jnz    _div_loop1
_div_loop_fin1:
	mov	cx,bx
_print_loop1:
	pop	eax
	add	eax,0x30
	call	write_char
	loop	_print_loop1

	pop	edx
	pop	ecx
	pop	ebx
	pop eax
	ret