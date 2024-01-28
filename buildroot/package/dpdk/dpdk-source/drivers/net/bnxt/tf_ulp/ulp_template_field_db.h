/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2014-2020 Broadcom
 * All rights reserved.
 */

#ifndef ULP_HDR_FIELD_ENUMS_H_
#define ULP_HDR_FIELD_ENUMS_H_

enum bnxt_ulp_hf0 {
	BNXT_ULP_HF0_IDX_SVIF_INDEX              = 0,
	BNXT_ULP_HF0_IDX_O_ETH_DMAC              = 1,
	BNXT_ULP_HF0_IDX_O_ETH_SMAC              = 2,
	BNXT_ULP_HF0_IDX_O_ETH_TYPE              = 3,
	BNXT_ULP_HF0_IDX_OO_VLAN_CFI_PRI         = 4,
	BNXT_ULP_HF0_IDX_OO_VLAN_VID             = 5,
	BNXT_ULP_HF0_IDX_OO_VLAN_TYPE            = 6,
	BNXT_ULP_HF0_IDX_OI_VLAN_CFI_PRI         = 7,
	BNXT_ULP_HF0_IDX_OI_VLAN_VID             = 8,
	BNXT_ULP_HF0_IDX_OI_VLAN_TYPE            = 9,
	BNXT_ULP_HF0_IDX_O_IPV4_VER              = 10,
	BNXT_ULP_HF0_IDX_O_IPV4_TOS              = 11,
	BNXT_ULP_HF0_IDX_O_IPV4_LEN              = 12,
	BNXT_ULP_HF0_IDX_O_IPV4_FRAG_ID          = 13,
	BNXT_ULP_HF0_IDX_O_IPV4_FRAG_OFF         = 14,
	BNXT_ULP_HF0_IDX_O_IPV4_TTL              = 15,
	BNXT_ULP_HF0_IDX_O_IPV4_NEXT_PID         = 16,
	BNXT_ULP_HF0_IDX_O_IPV4_CSUM             = 17,
	BNXT_ULP_HF0_IDX_O_IPV4_SRC_ADDR         = 18,
	BNXT_ULP_HF0_IDX_O_IPV4_DST_ADDR         = 19,
	BNXT_ULP_HF0_IDX_O_UDP_SRC_PORT          = 20,
	BNXT_ULP_HF0_IDX_O_UDP_DST_PORT          = 21,
	BNXT_ULP_HF0_IDX_O_UDP_LENGTH            = 22,
	BNXT_ULP_HF0_IDX_O_UDP_CSUM              = 23
};

enum bnxt_ulp_hf1 {
	BNXT_ULP_HF1_IDX_SVIF_INDEX              = 0,
	BNXT_ULP_HF1_IDX_O_ETH_DMAC              = 1,
	BNXT_ULP_HF1_IDX_O_ETH_SMAC              = 2,
	BNXT_ULP_HF1_IDX_O_ETH_TYPE              = 3,
	BNXT_ULP_HF1_IDX_OO_VLAN_CFI_PRI         = 4,
	BNXT_ULP_HF1_IDX_OO_VLAN_VID             = 5,
	BNXT_ULP_HF1_IDX_OO_VLAN_TYPE            = 6,
	BNXT_ULP_HF1_IDX_OI_VLAN_CFI_PRI         = 7,
	BNXT_ULP_HF1_IDX_OI_VLAN_VID             = 8,
	BNXT_ULP_HF1_IDX_OI_VLAN_TYPE            = 9,
	BNXT_ULP_HF1_IDX_O_IPV4_VER              = 10,
	BNXT_ULP_HF1_IDX_O_IPV4_TOS              = 11,
	BNXT_ULP_HF1_IDX_O_IPV4_LEN              = 12,
	BNXT_ULP_HF1_IDX_O_IPV4_FRAG_ID          = 13,
	BNXT_ULP_HF1_IDX_O_IPV4_FRAG_OFF         = 14,
	BNXT_ULP_HF1_IDX_O_IPV4_TTL              = 15,
	BNXT_ULP_HF1_IDX_O_IPV4_NEXT_PID         = 16,
	BNXT_ULP_HF1_IDX_O_IPV4_CSUM             = 17,
	BNXT_ULP_HF1_IDX_O_IPV4_SRC_ADDR         = 18,
	BNXT_ULP_HF1_IDX_O_IPV4_DST_ADDR         = 19,
	BNXT_ULP_HF1_IDX_O_UDP_SRC_PORT          = 20,
	BNXT_ULP_HF1_IDX_O_UDP_DST_PORT          = 21,
	BNXT_ULP_HF1_IDX_O_UDP_LENGTH            = 22,
	BNXT_ULP_HF1_IDX_O_UDP_CSUM              = 23
};

enum bnxt_ulp_hf2 {
	BNXT_ULP_HF2_IDX_SVIF_INDEX              = 0,
	BNXT_ULP_HF2_IDX_O_ETH_DMAC              = 1,
	BNXT_ULP_HF2_IDX_O_ETH_SMAC              = 2,
	BNXT_ULP_HF2_IDX_O_ETH_TYPE              = 3,
	BNXT_ULP_HF2_IDX_OO_VLAN_CFI_PRI         = 4,
	BNXT_ULP_HF2_IDX_OO_VLAN_VID             = 5,
	BNXT_ULP_HF2_IDX_OO_VLAN_TYPE            = 6,
	BNXT_ULP_HF2_IDX_OI_VLAN_CFI_PRI         = 7,
	BNXT_ULP_HF2_IDX_OI_VLAN_VID             = 8,
	BNXT_ULP_HF2_IDX_OI_VLAN_TYPE            = 9,
	BNXT_ULP_HF2_IDX_O_IPV4_VER              = 10,
	BNXT_ULP_HF2_IDX_O_IPV4_TOS              = 11,
	BNXT_ULP_HF2_IDX_O_IPV4_LEN              = 12,
	BNXT_ULP_HF2_IDX_O_IPV4_FRAG_ID          = 13,
	BNXT_ULP_HF2_IDX_O_IPV4_FRAG_OFF         = 14,
	BNXT_ULP_HF2_IDX_O_IPV4_TTL              = 15,
	BNXT_ULP_HF2_IDX_O_IPV4_NEXT_PID         = 16,
	BNXT_ULP_HF2_IDX_O_IPV4_CSUM             = 17,
	BNXT_ULP_HF2_IDX_O_IPV4_SRC_ADDR         = 18,
	BNXT_ULP_HF2_IDX_O_IPV4_DST_ADDR         = 19,
	BNXT_ULP_HF2_IDX_O_UDP_SRC_PORT          = 20,
	BNXT_ULP_HF2_IDX_O_UDP_DST_PORT          = 21,
	BNXT_ULP_HF2_IDX_O_UDP_LENGTH            = 22,
	BNXT_ULP_HF2_IDX_O_UDP_CSUM              = 23,
	BNXT_ULP_HF2_IDX_T_VXLAN_FLAGS           = 24,
	BNXT_ULP_HF2_IDX_T_VXLAN_RSVD0           = 25,
	BNXT_ULP_HF2_IDX_T_VXLAN_VNI             = 26,
	BNXT_ULP_HF2_IDX_T_VXLAN_RSVD1           = 27,
	BNXT_ULP_HF2_IDX_I_ETH_DMAC              = 28,
	BNXT_ULP_HF2_IDX_I_ETH_SMAC              = 29,
	BNXT_ULP_HF2_IDX_I_ETH_TYPE              = 30,
	BNXT_ULP_HF2_IDX_IO_VLAN_CFI_PRI         = 31,
	BNXT_ULP_HF2_IDX_IO_VLAN_VID             = 32,
	BNXT_ULP_HF2_IDX_IO_VLAN_TYPE            = 33,
	BNXT_ULP_HF2_IDX_II_VLAN_CFI_PRI         = 34,
	BNXT_ULP_HF2_IDX_II_VLAN_VID             = 35,
	BNXT_ULP_HF2_IDX_II_VLAN_TYPE            = 36,
	BNXT_ULP_HF2_IDX_I_IPV4_VER              = 37,
	BNXT_ULP_HF2_IDX_I_IPV4_TOS              = 38,
	BNXT_ULP_HF2_IDX_I_IPV4_LEN              = 39,
	BNXT_ULP_HF2_IDX_I_IPV4_FRAG_ID          = 40,
	BNXT_ULP_HF2_IDX_I_IPV4_FRAG_OFF         = 41,
	BNXT_ULP_HF2_IDX_I_IPV4_TTL              = 42,
	BNXT_ULP_HF2_IDX_I_IPV4_NEXT_PID         = 43,
	BNXT_ULP_HF2_IDX_I_IPV4_CSUM             = 44,
	BNXT_ULP_HF2_IDX_I_IPV4_SRC_ADDR         = 45,
	BNXT_ULP_HF2_IDX_I_IPV4_DST_ADDR         = 46,
	BNXT_ULP_HF2_IDX_I_UDP_SRC_PORT          = 47,
	BNXT_ULP_HF2_IDX_I_UDP_DST_PORT          = 48,
	BNXT_ULP_HF2_IDX_I_UDP_LENGTH            = 49,
	BNXT_ULP_HF2_IDX_I_UDP_CSUM              = 50
};

enum bnxt_ulp_hf_bitmask0 {
	BNXT_ULP_HF0_BITMASK_SVIF_INDEX          = 0x8000000000000000,
	BNXT_ULP_HF0_BITMASK_O_ETH_DMAC          = 0x4000000000000000,
	BNXT_ULP_HF0_BITMASK_O_ETH_SMAC          = 0x2000000000000000,
	BNXT_ULP_HF0_BITMASK_O_ETH_TYPE          = 0x1000000000000000,
	BNXT_ULP_HF0_BITMASK_OO_VLAN_CFI_PRI     = 0x0800000000000000,
	BNXT_ULP_HF0_BITMASK_OO_VLAN_VID         = 0x0400000000000000,
	BNXT_ULP_HF0_BITMASK_OO_VLAN_TYPE        = 0x0200000000000000,
	BNXT_ULP_HF0_BITMASK_OI_VLAN_CFI_PRI     = 0x0100000000000000,
	BNXT_ULP_HF0_BITMASK_OI_VLAN_VID         = 0x0080000000000000,
	BNXT_ULP_HF0_BITMASK_OI_VLAN_TYPE        = 0x0040000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_VER          = 0x0020000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_TOS          = 0x0010000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_LEN          = 0x0008000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_FRAG_ID      = 0x0004000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_FRAG_OFF     = 0x0002000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_TTL          = 0x0001000000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_NEXT_PID     = 0x0000800000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_CSUM         = 0x0000400000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_SRC_ADDR     = 0x0000200000000000,
	BNXT_ULP_HF0_BITMASK_O_IPV4_DST_ADDR     = 0x0000100000000000,
	BNXT_ULP_HF0_BITMASK_O_UDP_SRC_PORT      = 0x0000080000000000,
	BNXT_ULP_HF0_BITMASK_O_UDP_DST_PORT      = 0x0000040000000000,
	BNXT_ULP_HF0_BITMASK_O_UDP_LENGTH        = 0x0000020000000000,
	BNXT_ULP_HF0_BITMASK_O_UDP_CSUM          = 0x0000010000000000
};
enum bnxt_ulp_hf_bitmask1 {
	BNXT_ULP_HF1_BITMASK_SVIF_INDEX          = 0x8000000000000000,
	BNXT_ULP_HF1_BITMASK_O_ETH_DMAC          = 0x4000000000000000,
	BNXT_ULP_HF1_BITMASK_O_ETH_SMAC          = 0x2000000000000000,
	BNXT_ULP_HF1_BITMASK_O_ETH_TYPE          = 0x1000000000000000,
	BNXT_ULP_HF1_BITMASK_OO_VLAN_CFI_PRI     = 0x0800000000000000,
	BNXT_ULP_HF1_BITMASK_OO_VLAN_VID         = 0x0400000000000000,
	BNXT_ULP_HF1_BITMASK_OO_VLAN_TYPE        = 0x0200000000000000,
	BNXT_ULP_HF1_BITMASK_OI_VLAN_CFI_PRI     = 0x0100000000000000,
	BNXT_ULP_HF1_BITMASK_OI_VLAN_VID         = 0x0080000000000000,
	BNXT_ULP_HF1_BITMASK_OI_VLAN_TYPE        = 0x0040000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_VER          = 0x0020000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_TOS          = 0x0010000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_LEN          = 0x0008000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_FRAG_ID      = 0x0004000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_FRAG_OFF     = 0x0002000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_TTL          = 0x0001000000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_NEXT_PID     = 0x0000800000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_CSUM         = 0x0000400000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_SRC_ADDR     = 0x0000200000000000,
	BNXT_ULP_HF1_BITMASK_O_IPV4_DST_ADDR     = 0x0000100000000000,
	BNXT_ULP_HF1_BITMASK_O_UDP_SRC_PORT      = 0x0000080000000000,
	BNXT_ULP_HF1_BITMASK_O_UDP_DST_PORT      = 0x0000040000000000,
	BNXT_ULP_HF1_BITMASK_O_UDP_LENGTH        = 0x0000020000000000,
	BNXT_ULP_HF1_BITMASK_O_UDP_CSUM          = 0x0000010000000000
};

enum bnxt_ulp_hf_bitmask2 {
	BNXT_ULP_HF2_BITMASK_SVIF_INDEX          = 0x8000000000000000,
	BNXT_ULP_HF2_BITMASK_O_ETH_DMAC          = 0x4000000000000000,
	BNXT_ULP_HF2_BITMASK_O_ETH_SMAC          = 0x2000000000000000,
	BNXT_ULP_HF2_BITMASK_O_ETH_TYPE          = 0x1000000000000000,
	BNXT_ULP_HF2_BITMASK_OO_VLAN_CFI_PRI     = 0x0800000000000000,
	BNXT_ULP_HF2_BITMASK_OO_VLAN_VID         = 0x0400000000000000,
	BNXT_ULP_HF2_BITMASK_OO_VLAN_TYPE        = 0x0200000000000000,
	BNXT_ULP_HF2_BITMASK_OI_VLAN_CFI_PRI     = 0x0100000000000000,
	BNXT_ULP_HF2_BITMASK_OI_VLAN_VID         = 0x0080000000000000,
	BNXT_ULP_HF2_BITMASK_OI_VLAN_TYPE        = 0x0040000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_VER          = 0x0020000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_TOS          = 0x0010000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_LEN          = 0x0008000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_FRAG_ID      = 0x0004000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_FRAG_OFF     = 0x0002000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_TTL          = 0x0001000000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_NEXT_PID     = 0x0000800000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_CSUM         = 0x0000400000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_SRC_ADDR     = 0x0000200000000000,
	BNXT_ULP_HF2_BITMASK_O_IPV4_DST_ADDR     = 0x0000100000000000,
	BNXT_ULP_HF2_BITMASK_O_UDP_SRC_PORT      = 0x0000080000000000,
	BNXT_ULP_HF2_BITMASK_O_UDP_DST_PORT      = 0x0000040000000000,
	BNXT_ULP_HF2_BITMASK_O_UDP_LENGTH        = 0x0000020000000000,
	BNXT_ULP_HF2_BITMASK_O_UDP_CSUM          = 0x0000010000000000,
	BNXT_ULP_HF2_BITMASK_T_VXLAN_FLAGS       = 0x0000008000000000,
	BNXT_ULP_HF2_BITMASK_T_VXLAN_RSVD0       = 0x0000004000000000,
	BNXT_ULP_HF2_BITMASK_T_VXLAN_VNI         = 0x0000002000000000,
	BNXT_ULP_HF2_BITMASK_T_VXLAN_RSVD1       = 0x0000001000000000,
	BNXT_ULP_HF2_BITMASK_I_ETH_DMAC          = 0x0000000800000000,
	BNXT_ULP_HF2_BITMASK_I_ETH_SMAC          = 0x0000000400000000,
	BNXT_ULP_HF2_BITMASK_I_ETH_TYPE          = 0x0000000200000000,
	BNXT_ULP_HF2_BITMASK_IO_VLAN_CFI_PRI     = 0x0000000100000000,
	BNXT_ULP_HF2_BITMASK_IO_VLAN_VID         = 0x0000000080000000,
	BNXT_ULP_HF2_BITMASK_IO_VLAN_TYPE        = 0x0000000040000000,
	BNXT_ULP_HF2_BITMASK_II_VLAN_CFI_PRI     = 0x0000000020000000,
	BNXT_ULP_HF2_BITMASK_II_VLAN_VID         = 0x0000000010000000,
	BNXT_ULP_HF2_BITMASK_II_VLAN_TYPE        = 0x0000000008000000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_VER          = 0x0000000004000000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_TOS          = 0x0000000002000000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_LEN          = 0x0000000001000000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_FRAG_ID      = 0x0000000000800000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_FRAG_OFF     = 0x0000000000400000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_TTL          = 0x0000000000200000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_NEXT_PID     = 0x0000000000100000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_CSUM         = 0x0000000000080000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_SRC_ADDR     = 0x0000000000040000,
	BNXT_ULP_HF2_BITMASK_I_IPV4_DST_ADDR     = 0x0000000000020000,
	BNXT_ULP_HF2_BITMASK_I_UDP_SRC_PORT      = 0x0000000000010000,
	BNXT_ULP_HF2_BITMASK_I_UDP_DST_PORT      = 0x0000000000008000,
	BNXT_ULP_HF2_BITMASK_I_UDP_LENGTH        = 0x0000000000004000,
	BNXT_ULP_HF2_BITMASK_I_UDP_CSUM          = 0x0000000000002000
};

#endif
