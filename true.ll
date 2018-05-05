
define void @sys_exit(i64 %error_code) inlinehint {
  call void asm sideeffect inteldialect "syscall", "{rax},{rdi}"(i64 60, i64 %error_code)
  ret void
}

define void @_start() {
  call void @sys_exit(i64 0)
  ret void
}
