section .data
;initial message of the stack frame
s_header db '------------------Stack Examine------------------'
s_address db 'Address'
s_value db 'Hex Value'
s_decvalue db 'Decimal value'
msg	db	'Stack frame:'
len	equ	$-msg
fmsg	db	'Frames found: '
flen	equ	$-fmsg
section .text
	global walk_stack
	extern writestr
	extern write_address
	extern write_address_value
	extern write_dec
	extern newline
	extern space
walk_stack:
; Create stack frame & save caller's EDI and EBX.
    push 	ebp
    mov  	ebp, esp
	sub	esp, 12
    mov  	[ebp - 4], edi	 ; push	edi
   	mov  	[ebp - 8], ebx 	 ; push ebx
	mov 	[ebp-12],ecx	 ;push ecx
;use sub not push to optimize performance
    ; Set up local registers.
    xor  	eax, eax  	 ; EAX = return value (number of stack frames found).
    ;mov  	ebx, [esp +  12]  ; EBX = old EBP.
    ; mode 1: trace previous ebp
    mov ebx,ebp
    ;mode 2: trace current ebp
.printMsg: ; use to print header
	push 49
	push s_header
	call writestr
	add esp,8
	call newline
	push 7
	push s_address
	call writestr
	add esp,8
	call space
	push 9
	push s_value
	call writestr
	add esp,8
	call space
	push 13
	push s_decvalue
	call writestr
	add esp,8
	call newline
.walk:
; Walk backwards through EBP linked list
; Print the address, content of address in hex and decimal of the current frame
	mov ecx,[ebx+0] ; use ecx to point to previous ebp
	test ecx,ecx ;check if ecx point to null
	jz .done ;jump to .done if true
	push 	eax			; preserve the number of frames have been found
	mov 	eax, ebx	; move the address of the current frame to EAX to print
	call 	write_address ;this function is modifed in display.asm use to print address store in eax
	call space
	mov eax,[ebx]
	call write_address
	call space
	call write_address_value ;this function is modifed in display.asm use to print decimal value store in eax
	mov eax,ebx ; use eax point to current ebp, we do this to print stack frame of function
	call newline
	push ebx ;store ebx, we need ebx to get the value of address
; now print content of stack frame from eax (current ebp) to ecx (previous ebp)
.printframe:
	call newline
	cmp eax,ecx
	je .continue ; if eax equal ecx, we jump to another stack frame
	add eax,4	 ; move eax to next frame
	call write_address
	call space
	mov ebx,eax 	; store eax content in ebx
	mov eax,[ebx]	; get contents of a memory address in ebx
	call write_address
	call space
	call write_address_value
	mov eax,ebx 	; restore eax
	jmp .printframe
; point ecx to next frame
.continue:
	pop ebx
	pop	eax			; pop out number of the current frame
    mov  ebx, [ebx +  0]  	; EBX = previous stack frame's BP.
	push flen
	push fmsg
	call writestr ;print Frame found:
	add esp,8
	inc  eax ;increase number of the current frame by 1
	push eax
	call write_dec ;printf number of the current frame
	pop eax
	call newline
	jmp	.walk ; loop
.done:
  	mov edi, [ebp - 4]		; pop edi
    mov ebx, [ebp - 8]		; pop ebx
    mov ecx, [ebp-12]		; pop ecx
    leave
    ret
