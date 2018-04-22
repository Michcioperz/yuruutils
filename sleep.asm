section .text
global _start
_start:
  pop rcx ;read argc
  sub rcx, 1
  cmp rcx, 0
  jz .usage
  
  pop rcx ;skip argv[0]

  .readNumber:
  xor rsi, rsi
  pop rcx ;read argument
  test rcx, rcx
  jz .exit
  .readDigit:
  xor rax, rax ;zero out rax so it's pure for al
  mov al, byte [rcx] ;read a byte of the string into a register
  test al, al ;see if it's a \0
  jz .sleepActually ;finish parsing if it is
  sub al, 48 ;subtract 48 so we have a value of the digit
  imul rsi, 10 ;multiply current total by 10
  add rsi, rax ;add the digit to the total
  add rcx, 1 ;move to the next byte
  jmp .readDigit

  .sleepActually:
  ;syscall time, fun time
  push qword 0 ;set number of nanoseconds
  push qword rsi ;set number of seconds
  xor rsi, rsi ;set second argument to null
  mov rdi, rsp ;point first argument to our time struct at stack top
  mov rax, 35 ;choose syscall 35 - nanosleep
  syscall ;start a syscall

  pop rcx ;clean up our struct
  pop rcx
  jmp .readNumber ;try to read another argument

  .exit:
  ;we're done here, time to leave
  mov rax, 60 ;syscall 60 - exit
  mov rdi, 0 ;exit code 0
  syscall

  .usage:
  ;TODO: print usage
  mov rax, 60
  mov rdi, 1
  syscall

