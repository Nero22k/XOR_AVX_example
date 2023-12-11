
.code
xor_avx proc    ; rcx = data, rdx = data_size, r8 = key, r9 = key_size

    vmovdqu ymm1, ymmword ptr [r8]  ; Load key into ymm1 which must be 32 bytes long

    ; Calculate the number of full blocks and remainder
    mov eax, edx
    xor edx, edx       ; Clear RDX for DIV instruction
    mov bl, 32
    div ebx            ; RAX = number of full blocks, RDX = remainder

full_block_loop:
    cmp al, 0
    je handle_remainder
    dec al

    vmovdqu ymm0, ymmword ptr [rcx + r10]   ; Load 32 bytes from the offset
    vpxor ymm0, ymm0, ymm1                  ; XOR operation
    vmovdqu ymmword ptr [rcx + r10], ymm0   ; Store back

    add r10d, 32          ; Move to the next 32-byte block
    jmp full_block_loop

handle_remainder:
    test dl, dl         ; Check if there is any remainder
    jz end_xor            ; Jump to end if no remainder

    ; Calculate the start of the remainder in the data
    lea rsi, [rcx + r10] ; rsi = start address of the remainder

    ; Process each remaining byte
    mov r10d, edx          ; r10 = number of remaining bytes
process_remainder_loop:
    test r10d, r10d
    jz end_xor            ; Exit loop if no more bytes to process

    ; Load a byte from data and key, XOR them, store the result back
    mov al, byte ptr [rsi]  ; Load byte from data
    xor al, byte ptr [r8]   ; XOR with byte from key
    mov byte ptr [rsi], al  ; Store result back

    inc rsi               ; Move to the next byte in data
    dec r10d              ; Decrement byte counter
    jmp process_remainder_loop

end_xor:
    vzeroupper            ; Clean up AVX state
    ret
xor_avx endp
end