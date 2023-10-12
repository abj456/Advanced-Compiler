; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the isdigit library call simplifier works correctly even for
; targets with 16-bit int.
;
; RUN: opt < %s -mtriple=avr-linux -passes=instcombine -S | FileCheck %s
; RUN: opt < %s -mtriple=msp430-freebsd -passes=instcombine -S | FileCheck %s

declare i16 @isdigit(i16)

declare void @sink(i16)

define void @fold_isdigit(i16 %c) {
; CHECK-LABEL: @fold_isdigit(
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 1)
; CHECK-NEXT:    call void @sink(i16 1)
; CHECK-NEXT:    call void @sink(i16 1)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    call void @sink(i16 0)
; CHECK-NEXT:    [[ISDIGITTMP:%.*]] = add i16 [[C:%.*]], -48
; CHECK-NEXT:    [[ISDIGIT:%.*]] = icmp ult i16 [[ISDIGITTMP]], 10
; CHECK-NEXT:    [[IC:%.*]] = zext i1 [[ISDIGIT]] to i16
; CHECK-NEXT:    call void @sink(i16 [[IC]])
; CHECK-NEXT:    ret void
;
  %i0 = call i16 @isdigit(i16 0)
  call void @sink(i16 %i0)

  %i1 = call i16 @isdigit(i16 1)
  call void @sink(i16 %i1)

  ; Fold isdigit('/') to 0.
  %i47 = call i16 @isdigit(i16 47)
  call void @sink(i16 %i47)

; Fold isdigit('0') to 1.
  %i48 = call i16 @isdigit(i16 48)
  call void @sink(i16 %i48)

  ; Fold isdigit('1') to 1.
  %i49 = call i16 @isdigit(i16 49)
  call void @sink(i16 %i49)

  ; Fold isdigit('9') to 1.
  %i57 = call i16 @isdigit(i16 57)
  call void @sink(i16 %i57)

  ; Fold isdigit(':') to 0.
  %i58 = call i16 @isdigit(i16 58)
  call void @sink(i16 %i58)

  %i127 = call i16 @isdigit(i16 127)
  call void @sink(i16 %i127)

  %i128 = call i16 @isdigit(i16 128)
  call void @sink(i16 %i128)

  %i255 = call i16 @isdigit(i16 255)
  call void @sink(i16 %i255)

  ; Fold isdigit(256) to 0.  The argument is required to be representable
  ; in unsigned char but it's a common mistake to call the function with
  ; other arguments and it's arguably safer to fold such calls than to
  ; let the library call return an arbitrary value or crash.
  %i256 = call i16 @isdigit(i16 256)
  call void @sink(i16 %i256)

  ; Same as above.
  %imax = call i16 @isdigit(i16 32767)
  call void @sink(i16 %imax)

  %ic = call i16 @isdigit(i16 %c)
  call void @sink(i16 %ic)

  ret void
}