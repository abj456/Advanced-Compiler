; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='function(scalarizer)' %s | FileCheck %s

; Unary fp
declare <2 x float> @llvm.sqrt.v2f32(<2 x float>)

; Binary fp
declare <2 x float> @llvm.minnum.v2f32(<2 x float>, <2 x float>)
declare <2 x float> @llvm.minimum.v2f32(<2 x float>, <2 x float>)
declare <2 x float> @llvm.maximum.v2f32(<2 x float>, <2 x float>)

; Ternary fp
declare <2 x float> @llvm.fma.v2f32(<2 x float>, <2 x float>, <2 x float>)

; Unary int
declare <2 x i32> @llvm.bswap.v2i32(<2 x i32>)

; Unary int plus constant scalar operand
declare <2 x i32> @llvm.ctlz.v2i32(<2 x i32>, i1)

; Unary fp plus any scalar operand
declare <2 x float> @llvm.powi.v2f32.i32(<2 x float>, i32)

; Binary int plus constant scalar operand
declare <2 x i32> @llvm.smul.fix.sat.v2i32(<2 x i32>, <2 x i32>, i32)
declare <2 x i32> @llvm.umul.fix.sat.v2i32(<2 x i32>, <2 x i32>, i32)

declare <2 x i32> @llvm.fptosi.sat.v2i32.v2f32(<2 x float>)
declare <2 x i32> @llvm.fptoui.sat.v2i32.v2f32(<2 x float>)

; Bool return type, overloaded on fp operand type
declare <2 x i1> @llvm.is.fpclass(<2 x float>, i32)


define <2 x float> @scalarize_sqrt_v2f32(<2 x float> %x) #0 {
; CHECK-LABEL: @scalarize_sqrt_v2f32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[SQRT_I0:%.*]] = call float @llvm.sqrt.f32(float [[X_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[SQRT_I1:%.*]] = call float @llvm.sqrt.f32(float [[X_I1]])
; CHECK-NEXT:    [[SQRT_UPTO0:%.*]] = insertelement <2 x float> poison, float [[SQRT_I0]], i64 0
; CHECK-NEXT:    [[SQRT:%.*]] = insertelement <2 x float> [[SQRT_UPTO0]], float [[SQRT_I1]], i64 1
; CHECK-NEXT:    ret <2 x float> [[SQRT]]
;
  %sqrt = call <2 x float> @llvm.sqrt.v2f32(<2 x float> %x)
  ret <2 x float> %sqrt
}

define <2 x float> @scalarize_minnum_v2f32(<2 x float> %x, <2 x float> %y) #0 {
; CHECK-LABEL: @scalarize_minnum_v2f32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[Y_I0:%.*]] = extractelement <2 x float> [[Y:%.*]], i64 0
; CHECK-NEXT:    [[MINNUM_I0:%.*]] = call float @llvm.minnum.f32(float [[X_I0]], float [[Y_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[Y_I1:%.*]] = extractelement <2 x float> [[Y]], i64 1
; CHECK-NEXT:    [[MINNUM_I1:%.*]] = call float @llvm.minnum.f32(float [[X_I1]], float [[Y_I1]])
; CHECK-NEXT:    [[MINNUM_UPTO0:%.*]] = insertelement <2 x float> poison, float [[MINNUM_I0]], i64 0
; CHECK-NEXT:    [[MINNUM:%.*]] = insertelement <2 x float> [[MINNUM_UPTO0]], float [[MINNUM_I1]], i64 1
; CHECK-NEXT:    ret <2 x float> [[MINNUM]]
;
  %minnum = call <2 x float> @llvm.minnum.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %minnum
}

define <2 x float> @scalarize_minimum_v2f32(<2 x float> %x, <2 x float> %y) #0 {
; CHECK-LABEL: @scalarize_minimum_v2f32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[Y_I0:%.*]] = extractelement <2 x float> [[Y:%.*]], i64 0
; CHECK-NEXT:    [[MINIMUM_I0:%.*]] = call float @llvm.minimum.f32(float [[X_I0]], float [[Y_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[Y_I1:%.*]] = extractelement <2 x float> [[Y]], i64 1
; CHECK-NEXT:    [[MINIMUM_I1:%.*]] = call float @llvm.minimum.f32(float [[X_I1]], float [[Y_I1]])
; CHECK-NEXT:    [[MINIMUM_UPTO0:%.*]] = insertelement <2 x float> poison, float [[MINIMUM_I0]], i64 0
; CHECK-NEXT:    [[MINIMUM:%.*]] = insertelement <2 x float> [[MINIMUM_UPTO0]], float [[MINIMUM_I1]], i64 1
; CHECK-NEXT:    ret <2 x float> [[MINIMUM]]
;
  %minimum = call <2 x float> @llvm.minimum.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %minimum
}

define <2 x float> @scalarize_maximum_v2f32(<2 x float> %x, <2 x float> %y) #0 {
; CHECK-LABEL: @scalarize_maximum_v2f32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[Y_I0:%.*]] = extractelement <2 x float> [[Y:%.*]], i64 0
; CHECK-NEXT:    [[MAXIMUM_I0:%.*]] = call float @llvm.maximum.f32(float [[X_I0]], float [[Y_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[Y_I1:%.*]] = extractelement <2 x float> [[Y]], i64 1
; CHECK-NEXT:    [[MAXIMUM_I1:%.*]] = call float @llvm.maximum.f32(float [[X_I1]], float [[Y_I1]])
; CHECK-NEXT:    [[MAXIMUM_UPTO0:%.*]] = insertelement <2 x float> poison, float [[MAXIMUM_I0]], i64 0
; CHECK-NEXT:    [[MAXIMUM:%.*]] = insertelement <2 x float> [[MAXIMUM_UPTO0]], float [[MAXIMUM_I1]], i64 1
; CHECK-NEXT:    ret <2 x float> [[MAXIMUM]]
;
  %maximum = call <2 x float> @llvm.maximum.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %maximum
}

define <2 x float> @scalarize_fma_v2f32(<2 x float> %x, <2 x float> %y, <2 x float> %z) #0 {
; CHECK-LABEL: @scalarize_fma_v2f32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[Y_I0:%.*]] = extractelement <2 x float> [[Y:%.*]], i64 0
; CHECK-NEXT:    [[Z_I0:%.*]] = extractelement <2 x float> [[Z:%.*]], i64 0
; CHECK-NEXT:    [[FMA_I0:%.*]] = call float @llvm.fma.f32(float [[X_I0]], float [[Y_I0]], float [[Z_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[Y_I1:%.*]] = extractelement <2 x float> [[Y]], i64 1
; CHECK-NEXT:    [[Z_I1:%.*]] = extractelement <2 x float> [[Z]], i64 1
; CHECK-NEXT:    [[FMA_I1:%.*]] = call float @llvm.fma.f32(float [[X_I1]], float [[Y_I1]], float [[Z_I1]])
; CHECK-NEXT:    [[FMA_UPTO0:%.*]] = insertelement <2 x float> poison, float [[FMA_I0]], i64 0
; CHECK-NEXT:    [[FMA:%.*]] = insertelement <2 x float> [[FMA_UPTO0]], float [[FMA_I1]], i64 1
; CHECK-NEXT:    ret <2 x float> [[FMA]]
;
  %fma = call <2 x float> @llvm.fma.v2f32(<2 x float> %x, <2 x float> %y, <2 x float> %z)
  ret <2 x float> %fma
}

define <2 x i32> @scalarize_bswap_v2i32(<2 x i32> %x) #0 {
; CHECK-LABEL: @scalarize_bswap_v2i32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x i32> [[X:%.*]], i64 0
; CHECK-NEXT:    [[BSWAP_I0:%.*]] = call i32 @llvm.bswap.i32(i32 [[X_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x i32> [[X]], i64 1
; CHECK-NEXT:    [[BSWAP_I1:%.*]] = call i32 @llvm.bswap.i32(i32 [[X_I1]])
; CHECK-NEXT:    [[BSWAP_UPTO0:%.*]] = insertelement <2 x i32> poison, i32 [[BSWAP_I0]], i64 0
; CHECK-NEXT:    [[BSWAP:%.*]] = insertelement <2 x i32> [[BSWAP_UPTO0]], i32 [[BSWAP_I1]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[BSWAP]]
;
  %bswap = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %x)
  ret <2 x i32> %bswap
}

define <2 x i32> @scalarize_ctlz_v2i32(<2 x i32> %x) #0 {
; CHECK-LABEL: @scalarize_ctlz_v2i32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x i32> [[X:%.*]], i64 0
; CHECK-NEXT:    [[CTLZ_I0:%.*]] = call i32 @llvm.ctlz.i32(i32 [[X_I0]], i1 true)
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x i32> [[X]], i64 1
; CHECK-NEXT:    [[CTLZ_I1:%.*]] = call i32 @llvm.ctlz.i32(i32 [[X_I1]], i1 true)
; CHECK-NEXT:    [[CTLZ_UPTO0:%.*]] = insertelement <2 x i32> poison, i32 [[CTLZ_I0]], i64 0
; CHECK-NEXT:    [[CTLZ:%.*]] = insertelement <2 x i32> [[CTLZ_UPTO0]], i32 [[CTLZ_I1]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %x, i1 true)
  ret <2 x i32> %ctlz
}

define <2 x float> @scalarize_powi_v2f32(<2 x float> %x, i32 %y) #0 {
; CHECK-LABEL: @scalarize_powi_v2f32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[POWI_I0:%.*]] = call float @llvm.powi.f32.i32(float [[X_I0]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[POWI_I1:%.*]] = call float @llvm.powi.f32.i32(float [[X_I1]], i32 [[Y]])
; CHECK-NEXT:    [[POWI_UPTO0:%.*]] = insertelement <2 x float> poison, float [[POWI_I0]], i64 0
; CHECK-NEXT:    [[POWI:%.*]] = insertelement <2 x float> [[POWI_UPTO0]], float [[POWI_I1]], i64 1
; CHECK-NEXT:    ret <2 x float> [[POWI]]
;
  %powi = call <2 x float> @llvm.powi.v2f32.i32(<2 x float> %x, i32 %y)
  ret <2 x float> %powi
}

define <2 x i32> @scalarize_smul_fix_sat_v2i32(<2 x i32> %x) #0 {
; CHECK-LABEL: @scalarize_smul_fix_sat_v2i32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x i32> [[X:%.*]], i64 0
; CHECK-NEXT:    [[SMULFIXSAT_I0:%.*]] = call i32 @llvm.smul.fix.sat.i32(i32 [[X_I0]], i32 5, i32 31)
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x i32> [[X]], i64 1
; CHECK-NEXT:    [[SMULFIXSAT_I1:%.*]] = call i32 @llvm.smul.fix.sat.i32(i32 [[X_I1]], i32 19, i32 31)
; CHECK-NEXT:    [[SMULFIXSAT_UPTO0:%.*]] = insertelement <2 x i32> poison, i32 [[SMULFIXSAT_I0]], i64 0
; CHECK-NEXT:    [[SMULFIXSAT:%.*]] = insertelement <2 x i32> [[SMULFIXSAT_UPTO0]], i32 [[SMULFIXSAT_I1]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[SMULFIXSAT]]
;
  %smulfixsat = call <2 x i32> @llvm.smul.fix.sat.v2i32(<2 x i32> %x, <2 x i32> <i32 5, i32 19>, i32 31)
  ret <2 x i32> %smulfixsat
}

define <2 x i32> @scalarize_umul_fix_sat_v2i32(<2 x i32> %x) #0 {
; CHECK-LABEL: @scalarize_umul_fix_sat_v2i32(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x i32> [[X:%.*]], i64 0
; CHECK-NEXT:    [[UMULFIXSAT_I0:%.*]] = call i32 @llvm.umul.fix.sat.i32(i32 [[X_I0]], i32 5, i32 31)
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x i32> [[X]], i64 1
; CHECK-NEXT:    [[UMULFIXSAT_I1:%.*]] = call i32 @llvm.umul.fix.sat.i32(i32 [[X_I1]], i32 19, i32 31)
; CHECK-NEXT:    [[UMULFIXSAT_UPTO0:%.*]] = insertelement <2 x i32> poison, i32 [[UMULFIXSAT_I0]], i64 0
; CHECK-NEXT:    [[UMULFIXSAT:%.*]] = insertelement <2 x i32> [[UMULFIXSAT_UPTO0]], i32 [[UMULFIXSAT_I1]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[UMULFIXSAT]]
;
  %umulfixsat = call <2 x i32> @llvm.umul.fix.sat.v2i32(<2 x i32> %x, <2 x i32> <i32 5, i32 19>, i32 31)
  ret <2 x i32> %umulfixsat
}

define <2 x i32> @scalarize_fptosi_sat(<2 x float> %x) #0 {
; CHECK-LABEL: @scalarize_fptosi_sat(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[SAT_I0:%.*]] = call i32 @llvm.fptosi.sat.i32.f32(float [[X_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[SAT_I1:%.*]] = call i32 @llvm.fptosi.sat.i32.f32(float [[X_I1]])
; CHECK-NEXT:    [[SAT_UPTO0:%.*]] = insertelement <2 x i32> poison, i32 [[SAT_I0]], i64 0
; CHECK-NEXT:    [[SAT:%.*]] = insertelement <2 x i32> [[SAT_UPTO0]], i32 [[SAT_I1]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[SAT]]
;
  %sat = call <2 x i32> @llvm.fptosi.sat.v2i32.v2f32(<2 x float> %x)
  ret <2 x i32> %sat
}

define <2 x i32> @scalarize_fptoui_sat(<2 x float> %x) #0 {
; CHECK-LABEL: @scalarize_fptoui_sat(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[SAT_I0:%.*]] = call i32 @llvm.fptoui.sat.i32.f32(float [[X_I0]])
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[SAT_I1:%.*]] = call i32 @llvm.fptoui.sat.i32.f32(float [[X_I1]])
; CHECK-NEXT:    [[SAT_UPTO0:%.*]] = insertelement <2 x i32> poison, i32 [[SAT_I0]], i64 0
; CHECK-NEXT:    [[SAT:%.*]] = insertelement <2 x i32> [[SAT_UPTO0]], i32 [[SAT_I1]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[SAT]]
;
  %sat = call <2 x i32> @llvm.fptoui.sat.v2i32.v2f32(<2 x float> %x)
  ret <2 x i32> %sat
}

define <2 x i1> @scalarize_is_fpclass(<2 x float> %x) #0 {
; CHECK-LABEL: @scalarize_is_fpclass(
; CHECK-NEXT:    [[X_I0:%.*]] = extractelement <2 x float> [[X:%.*]], i64 0
; CHECK-NEXT:    [[ISFPCLASS_I0:%.*]] = call i1 @llvm.is.fpclass.f32(float [[X_I0]], i32 123)
; CHECK-NEXT:    [[X_I1:%.*]] = extractelement <2 x float> [[X]], i64 1
; CHECK-NEXT:    [[ISFPCLASS_I1:%.*]] = call i1 @llvm.is.fpclass.f32(float [[X_I1]], i32 123)
; CHECK-NEXT:    [[ISFPCLASS_UPTO0:%.*]] = insertelement <2 x i1> poison, i1 [[ISFPCLASS_I0]], i64 0
; CHECK-NEXT:    [[ISFPCLASS:%.*]] = insertelement <2 x i1> [[ISFPCLASS_UPTO0]], i1 [[ISFPCLASS_I1]], i64 1
; CHECK-NEXT:    ret <2 x i1> [[ISFPCLASS]]
;
  %isfpclass = call <2 x i1> @llvm.is.fpclass(<2 x float> %x, i32 123)
  ret <2 x i1> %isfpclass
}