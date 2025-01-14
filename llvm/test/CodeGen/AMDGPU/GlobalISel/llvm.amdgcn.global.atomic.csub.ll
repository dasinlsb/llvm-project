; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1030 -verify-machineinstrs < %s | FileCheck %s -check-prefix=GFX10
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1031 -verify-machineinstrs < %s | FileCheck %s -check-prefix=GFX10
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1100 -verify-machineinstrs < %s | FileCheck %s -check-prefix=GFX11

define i32 @global_atomic_csub(ptr addrspace(1) %ptr, i32 %data) {
; GFX10-LABEL: global_atomic_csub:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    global_atomic_csub v0, v[0:1], v2, off glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: global_atomic_csub:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    global_atomic_csub_u32 v0, v[0:1], v2, off glc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %ret = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %ptr, i32 %data)
  ret i32 %ret
}

define i32 @global_atomic_csub_offset(ptr addrspace(1) %ptr, i32 %data) {
; GFX10-LABEL: global_atomic_csub_offset:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_mov_b64 s[4:5], 0x1000
; GFX10-NEXT:    v_mov_b32_e32 v3, s4
; GFX10-NEXT:    v_mov_b32_e32 v4, s5
; GFX10-NEXT:    v_add_co_u32 v0, vcc_lo, v0, v3
; GFX10-NEXT:    v_add_co_ci_u32_e32 v1, vcc_lo, v1, v4, vcc_lo
; GFX10-NEXT:    global_atomic_csub v0, v[0:1], v2, off glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: global_atomic_csub_offset:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_mov_b64 s[0:1], 0x1000
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_dual_mov_b32 v4, s1 :: v_dual_mov_b32 v3, s0
; GFX11-NEXT:    v_add_co_u32 v0, vcc_lo, v0, v3
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2)
; GFX11-NEXT:    v_add_co_ci_u32_e32 v1, vcc_lo, v1, v4, vcc_lo
; GFX11-NEXT:    global_atomic_csub_u32 v0, v[0:1], v2, off glc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr i32, ptr addrspace(1) %ptr, i64 1024
  %ret = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %gep, i32 %data)
  ret i32 %ret
}

define void @global_atomic_csub_nortn(ptr addrspace(1) %ptr, i32 %data) {
; GFX10-LABEL: global_atomic_csub_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    global_atomic_csub v0, v[0:1], v2, off glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: global_atomic_csub_nortn:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    global_atomic_csub_u32 v0, v[0:1], v2, off glc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %ret = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %ptr, i32 %data)
  ret void
}

define void @global_atomic_csub_offset_nortn(ptr addrspace(1) %ptr, i32 %data) {
; GFX10-LABEL: global_atomic_csub_offset_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_mov_b64 s[4:5], 0x1000
; GFX10-NEXT:    v_mov_b32_e32 v3, s4
; GFX10-NEXT:    v_mov_b32_e32 v4, s5
; GFX10-NEXT:    v_add_co_u32 v0, vcc_lo, v0, v3
; GFX10-NEXT:    v_add_co_ci_u32_e32 v1, vcc_lo, v1, v4, vcc_lo
; GFX10-NEXT:    global_atomic_csub v0, v[0:1], v2, off glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: global_atomic_csub_offset_nortn:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_mov_b64 s[0:1], 0x1000
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_dual_mov_b32 v4, s1 :: v_dual_mov_b32 v3, s0
; GFX11-NEXT:    v_add_co_u32 v0, vcc_lo, v0, v3
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2)
; GFX11-NEXT:    v_add_co_ci_u32_e32 v1, vcc_lo, v1, v4, vcc_lo
; GFX11-NEXT:    global_atomic_csub_u32 v0, v[0:1], v2, off glc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr i32, ptr addrspace(1) %ptr, i64 1024
  %ret = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %gep, i32 %data)
  ret void
}

define amdgpu_kernel void @global_atomic_csub_sgpr_base_offset(ptr addrspace(1) %ptr, i32 %data) {
; GFX10-LABEL: global_atomic_csub_sgpr_base_offset:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dword s2, s[4:5], 0x8
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0x1000
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_atomic_csub v0, v1, v0, s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    global_store_dword v[0:1], v0, off
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: global_atomic_csub_sgpr_base_offset:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b32 s2, s[0:1], 0x8
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    v_dual_mov_b32 v1, 0x1000 :: v_dual_mov_b32 v0, s2
; GFX11-NEXT:    global_atomic_csub_u32 v0, v1, v0, s[0:1] glc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    global_store_b32 v[0:1], v0, off
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %gep = getelementptr i32, ptr addrspace(1) %ptr, i64 1024
  %ret = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %gep, i32 %data)
  store i32 %ret, ptr addrspace(1) undef
  ret void
}

define amdgpu_kernel void @global_atomic_csub_sgpr_base_offset_nortn(ptr addrspace(1) %ptr, i32 %data) {
; GFX10-LABEL: global_atomic_csub_sgpr_base_offset_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dword s2, s[4:5], 0x8
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0x1000
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_atomic_csub v0, v1, v0, s[0:1] glc
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: global_atomic_csub_sgpr_base_offset_nortn:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b32 s2, s[0:1], 0x8
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    v_dual_mov_b32 v1, 0x1000 :: v_dual_mov_b32 v0, s2
; GFX11-NEXT:    global_atomic_csub_u32 v0, v1, v0, s[0:1] glc
; GFX11-NEXT:    s_endpgm
  %gep = getelementptr i32, ptr addrspace(1) %ptr, i64 1024
  %ret = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %gep, i32 %data)
  ret void
}

declare i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) nocapture, i32) #1

attributes #0 = { nounwind willreturn }
attributes #1 = { argmemonly nounwind }
