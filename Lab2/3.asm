format ELF64

public _start
public exit
public print_symb

section '.bss' writable
  array db 15 dup (':')
  newline db 15 dup (0xA)
  place db 1
  count dq 0

section '.text' executable
  _start:
    xor rsi, rsi

  .iter1:
    xor rdi, rdi

    inc qword [count]           ; Упрощено обновление счетчика

  .iter2:
    mov al, [array + rdi]
    call print_symb
    inc rdi
    cmp rdi, qword [count]      ; Убрал промежуточное использование rbx
    jne .iter2

    mov al, [newline + rsi]
    call print_symb

    inc rsi
    cmp rsi, 15
    jne .iter1

    call exit

print_symb:
    mov [place], al
    mov eax, 4
    mov ebx, 1
    mov ecx, place
    mov edx, 1
    int 0x80
    ret

exit:
    mov eax, 1
    xor ebx, ebx                ; Использую xor для обнуления ebx
    int 0x80
