; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown -mattr=-sse4.2,+sse4.1 < %s | FileCheck %s

; Make sure we don't load from the location pointed to by %p
; twice: it has non-obvious performance implications, and
; the relevant transformation doesn't know how to update
; the chains correctly.
; PR10747

define <4 x i32> @test(ptr %p) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $3, 8(%rdi)
; CHECK-NEXT:    je .LBB0_1
; CHECK-NEXT:  # %bb.2:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_1:
; CHECK-NEXT:    movaps (%rdi), %xmm0
; CHECK-NEXT:    retq
  %v = load <4 x i32>, ptr %p
  %e = extractelement <4 x i32> %v, i32 2
  %cmp = icmp eq i32 %e, 3
  %sel = select i1 %cmp, <4 x i32> %v, <4 x i32> zeroinitializer
  ret <4 x i32> %sel
}