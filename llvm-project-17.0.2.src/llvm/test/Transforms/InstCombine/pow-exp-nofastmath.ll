; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define double @mypow(double %x, double %y) {
; CHECK-LABEL: @mypow(
; CHECK-NEXT:    [[CALL:%.*]] = call double @exp(double [[X:%.*]])
; CHECK-NEXT:    [[POW:%.*]] = call double @llvm.pow.f64(double [[CALL]], double [[Y:%.*]])
; CHECK-NEXT:    ret double [[POW]]
;
  %call = call double @exp(double %x)
  %pow = call double @llvm.pow.f64(double %call, double %y)
  ret double %pow
}

declare double @exp(double) #1
declare double @llvm.pow.f64(double, double)