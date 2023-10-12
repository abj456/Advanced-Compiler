; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=cmov -verify-machineinstrs | FileCheck %s

define i32 @func_f(i32 %X) {
; CHECK-LABEL: func_f:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    jns baz@PLT # TAILCALL
; CHECK-NEXT:  # %bb.1: # %cond_true
; CHECK-NEXT:    calll bar@PLT
; CHECK-NEXT:    jmp baz@PLT # TAILCALL
entry:
	%tmp1 = add i32 %X, 1
	%tmp = icmp slt i32 %tmp1, 0
	br i1 %tmp, label %cond_true, label %cond_next, !prof !1

cond_true:		; preds = %entry
	%tmp2 = tail call i32 (...) @bar( )
	br label %cond_next

cond_next:		; preds = %cond_true, %entry
	%tmp3 = tail call i32 (...) @baz( )
	ret i32 undef
}

declare i32 @bar(...)
declare i32 @baz(...)

; rdar://10633221
; rdar://11355268
define i32 @func_g(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_g:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovsl %ecx, %eax
; CHECK-NEXT:    retl
  %sub = sub nsw i32 %a, %b
  %cmp = icmp sgt i32 %sub, 0
  %cond = select i1 %cmp, i32 %sub, i32 0
  ret i32 %cond
}

; rdar://10734411
define i32 @func_h(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_h:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovlel %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp slt i32 %b, %a
  %sub = sub nsw i32 %a, %b
  %cond = select i1 %cmp, i32 %sub, i32 0
  ret i32 %cond
}

define i32 @func_i(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovlel %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp sgt i32 %a, %b
  %sub = sub nsw i32 %a, %b
  %cond = select i1 %cmp, i32 %sub, i32 0
  ret i32 %cond
}

define i32 @func_j(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_j:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovbel %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp ugt i32 %a, %b
  %sub = sub i32 %a, %b
  %cond = select i1 %cmp, i32 %sub, i32 0
  ret i32 %cond
}

define i32 @func_k(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_k:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovbel %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp ult i32 %b, %a
  %sub = sub i32 %a, %b
  %cond = select i1 %cmp, i32 %sub, i32 0
  ret i32 %cond
}

; redundant cmp instruction
define i32 @func_l(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_l:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovlel %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp slt i32 %b, %a
  %sub = sub nsw i32 %a, %b
  %cond = select i1 %cmp, i32 %sub, i32 %a
  ret i32 %cond
}

define i32 @func_m(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_m:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    subl %ecx, %eax
; CHECK-NEXT:    cmovgl %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp sgt i32 %a, %b
  %sub = sub nsw i32 %a, %b
  %cond = select i1 %cmp, i32 %b, i32 %sub
  ret i32 %cond
}

; (This used to test that an unsafe removal of cmp in bb.0 is not happening,
;  but now we can do so safely).
define i32 @func_l2(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_l2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    jne .LBB8_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    cmovll %ecx, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB8_2: # %if.else
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp eq i32 %b, %a
  %sub = sub nsw i32 %a, %b
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %cmp2 = icmp sgt i32 %b, %a
  %sel = select i1 %cmp2, i32 %sub, i32 %a
  ret i32 %sel

if.else:
  ret i32 %sub
}

define i32 @func_l3(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_l3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    jge .LBB9_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB9_2: # %if.else
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    retl
  %cmp = icmp sgt i32 %b, %a
  %sub = sub nsw i32 %a, %b
  br i1 %cmp, label %if.then, label %if.else

if.then:
  ret i32 %sub

if.else:
  %add = add nsw i32 %sub, 1
  ret i32 %add
}

; rdar://11830760
; When Movr0 is between sub and cmp, we need to move "Movr0" before sub.
define i32 @func_l4(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_l4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovll %ecx, %eax
; CHECK-NEXT:    retl
  %cmp = icmp sgt i32 %b, %a
  %sub = sub i32 %a, %b
  %.sub = select i1 %cmp, i32 0, i32 %sub
  ret i32 %.sub
}

; rdar://11540023
define i32 @func_n(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: func_n:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmpl %ecx, %eax
; CHECK-NEXT:    cmovsl %ecx, %eax
; CHECK-NEXT:    retl
  %sub = sub nsw i32 %x, %y
  %cmp = icmp slt i32 %sub, 0
  %y.x = select i1 %cmp, i32 %y, i32 %x
  ret i32 %y.x
}

; PR://13046
define void @func_o() nounwind uwtable {
; CHECK-LABEL: func_o:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB12_1
; CHECK-NEXT:  # %bb.2: # %if.end.i
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB12_5
; CHECK-NEXT:  # %bb.3: # %sw.bb
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB12_8
; CHECK-NEXT:  # %bb.4: # %if.end29
; CHECK-NEXT:    movzwl (%eax), %eax
; CHECK-NEXT:    imull $-13107, %eax, %eax # imm = 0xCCCD
; CHECK-NEXT:    rorw %ax
; CHECK-NEXT:    movzwl %ax, %eax
; CHECK-NEXT:    cmpl $6554, %eax # imm = 0x199A
; CHECK-NEXT:    jae .LBB12_5
; CHECK-NEXT:  .LBB12_8: # %if.then44
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB12_9
; CHECK-NEXT:  # %bb.10: # %if.else.i104
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB12_5: # %sw.default
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB12_7
; CHECK-NEXT:  # %bb.6: # %if.then.i96
; CHECK-NEXT:  .LBB12_1: # %if.then.i
; CHECK-NEXT:  .LBB12_9: # %if.then.i103
; CHECK-NEXT:  .LBB12_7: # %if.else.i97
entry:
  %0 = load i16, ptr undef, align 2
  br i1 undef, label %if.then.i, label %if.end.i

if.then.i:                                        ; preds = %entry
  unreachable

if.end.i:                                         ; preds = %entry
  br i1 undef, label %sw.bb, label %sw.default

sw.bb:                                            ; preds = %if.end.i
  br i1 undef, label %if.then44, label %if.end29

if.end29:                                         ; preds = %sw.bb
  %1 = urem i16 %0, 10
  %cmp25 = icmp eq i16 %1, 0
  %. = select i1 %cmp25, i16 2, i16 0
  br i1 %cmp25, label %if.then44, label %sw.default

sw.default:                                       ; preds = %if.end29, %if.end.i
  br i1 undef, label %if.then.i96, label %if.else.i97

if.then.i96:                                      ; preds = %sw.default
  unreachable

if.else.i97:                                      ; preds = %sw.default
  unreachable

if.then44:                                        ; preds = %if.end29, %sw.bb
  %aModeRefSel.1.ph = phi i16 [ %., %if.end29 ], [ 3, %sw.bb ]
  br i1 undef, label %if.then.i103, label %if.else.i104

if.then.i103:                                     ; preds = %if.then44
  unreachable

if.else.i104:                                     ; preds = %if.then44
  ret void
}

; rdar://11855129
define i32 @func_p(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: func_p:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    addl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmovsl %ecx, %eax
; CHECK-NEXT:    retl
  %add = add nsw i32 %b, %a
  %cmp = icmp sgt i32 %add, 0
  %add. = select i1 %cmp, i32 %add, i32 0
  ret i32 %add.
}

; PR13475
; We don't need an explicit cmp here. A sub/neg combo will do.

define i32 @func_q(i32 %a0, i32 %a1, i32 %a2) {
; CHECK-LABEL: func_q:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    sbbl %ecx, %ecx
; CHECK-NEXT:    negl %eax
; CHECK-NEXT:    xorl %ecx, %eax
; CHECK-NEXT:    retl
  %t1 = icmp ult i32 %a0, %a1
  %t2 = sub i32 %a1, %a0
  %t3 = select i1 %t1, i32 -1, i32 0
  %t4 = xor i32 %t2, %t3
  ret i32 %t4
}

; rdar://11873276
define ptr @func_r(ptr %base, ptr nocapture %offset, i32 %size) nounwind {
; CHECK-LABEL: func_r:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    movl (%edx), %ecx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    subl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    jl .LBB15_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %ecx, (%edx)
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:  .LBB15_2: # %return
; CHECK-NEXT:    retl
entry:
  %0 = load i32, ptr %offset, align 8
  %cmp = icmp slt i32 %0, %size
  br i1 %cmp, label %return, label %if.end

if.end:
  %sub = sub nsw i32 %0, %size
  store i32 %sub, ptr %offset, align 8
  %add.ptr = getelementptr inbounds i8, ptr %base, i32 %sub
  br label %return

return:
  %retval.0 = phi ptr [ %add.ptr, %if.end ], [ null, %entry ]
  ret ptr %retval.0
}

; Test optimizations of dec/inc.
define i32 @func_dec(i32 %a) nounwind {
; CHECK-LABEL: func_dec:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    decl %eax
; CHECK-NEXT:    cmovsl %ecx, %eax
; CHECK-NEXT:    retl
  %sub = sub nsw i32 %a, 1
  %cmp = icmp sgt i32 %sub, 0
  %cond = select i1 %cmp, i32 %sub, i32 0
  ret i32 %cond
}

define i32 @func_inc(i32 %a) nounwind {
; CHECK-LABEL: func_inc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    cmovsl %ecx, %eax
; CHECK-NEXT:    retl
  %add = add nsw i32 %a, 1
  %cmp = icmp sgt i32 %add, 0
  %cond = select i1 %cmp, i32 %add, i32 0
  ret i32 %cond
}

; PR13966
@b = common global i32 0, align 4
@a = common global i32 0, align 4
define i32 @func_test1(i32 %p1) nounwind uwtable {
; CHECK-LABEL: func_test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl b, %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    movl a, %eax
; CHECK-NEXT:    testl %eax, %ecx
; CHECK-NEXT:    je .LBB18_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    decl %eax
; CHECK-NEXT:    movl %eax, a
; CHECK-NEXT:  .LBB18_2: # %if.end
; CHECK-NEXT:    retl
entry:
  %t0 = load i32, ptr @b, align 4
  %cmp = icmp ult i32 %t0, %p1
  %conv = zext i1 %cmp to i32
  %t1 = load i32, ptr @a, align 4
  %and = and i32 %conv, %t1
  %conv1 = trunc i32 %and to i8
  %t2 = urem i8 %conv1, 3
  %tobool = icmp eq i8 %t2, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:
  %dec = add nsw i32 %t1, -1
  store i32 %dec, ptr @a, align 4
  br label %if.end

if.end:
  ret i32 undef
}

!1 = !{!"branch_weights", i32 2, i32 1}
