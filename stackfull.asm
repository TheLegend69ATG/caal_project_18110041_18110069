extern writestr,space,newline,write_address_value,write_address
extern printf,scanf
section .bss
input resd 1
section .data
EXIT_SUCCESS equ 0
SYS_EXIT equ 1
header dd "input"
format dd '%x'
section .text
global stackfull
stackfull:
push eax
push ebx
push 6
push header
call writestr
call newline
add esp,8
push input
push format
call scanf
add esp,8
mov ebx,[input]
mov eax,ebx
call write_address
call space
break:
mov eax,[ebx]
call write_address
call space
mov eax,[eax]
call write_address
pop ebx
pop eax
last:
ret


