format ELF64

public _start
public exit
public print_symb

section '.bss' writable
  number dq 5440848234
  result dq 0
  ten dq 10
  place db 1

section '.text' executable
  _start:
    mov rax, [number]
    xor rbx, rbx

  .sum_loop:
    xor rdx, rdx
    div qword [ten]
    add rbx, rdx
    test rax, rax            ; проверка на ноль
    jnz .sum_loop

    mov [result], rbx

    ; Выводим результат
    call print_symb

    mov eax, 60
    xor edi, edi
    syscall

print_symb:
    mov rax, [result]
    xor rbx, rbx

    cmp rax, 9
    jle .single_digit

    mov rcx, 10
  .loop:
    xor rdx, rdx
    div rcx
    push rdx
    inc rbx
    test rax, rax
    jnz .loop

  .print_loop:
    pop rax
    add rax, '0'
    mov [place], al

    mov eax, 1
    mov edi, 1
    mov rsi, place
    mov edx, 1
    syscall

    dec rbx
    jnz .print_loop

    ret

  .single_digit:
    add rax, '0'
    mov [place], al

    mov eax, 1
    mov edi, 1
    mov rsi, place
    mov edx, 1
    syscall
    ret

exit:
  mov eax, 1
  xor ebx, ebx
  int 0x80