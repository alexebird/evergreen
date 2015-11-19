typedef unsigned long btn_mask;
typedef unsigned long tyme;

#define BTN_MASK_SIZE 32
#define MASK_WIDTH 4

#define NULL_MASK 0b0000
#define BLU_MASK  0b1000
#define RED_MASK  0b0100
#define ALL_MASK  0b1100
#define HOLD_MASK 0b0001

#define MASK_BLU_INC_POINT   ( (BLU_MASK << MASK_WIDTH) | NULL_MASK )
#define MASK_BLU_DEC_POINT   ( (BLU_MASK << MASK_WIDTH*2) | (ALL_MASK << MASK_WIDTH) | BLU_MASK )

#define MASK_RED_INC_POINT   ( (RED_MASK << MASK_WIDTH) | NULL_MASK )
#define MASK_RED_DEC_POINT   ( (RED_MASK << MASK_WIDTH*2) | (ALL_MASK << MASK_WIDTH) | RED_MASK )

#define MASK_NEW_GAME1   ( ALL_MASK | HOLD_MASK )
#define MASK_NEW_GAME2   ( (BLU_MASK << MASK_WIDTH) | (ALL_MASK | HOLD_MASK) )
#define MASK_NEW_GAME3   ( (RED_MASK << MASK_WIDTH) | (ALL_MASK | HOLD_MASK) )

#define MASK_DEBUG   ( BLU_MASK | HOLD_MASK )

#define HOLD_DOWN_MILLIS 1000

#define MASK_x1 0b1111
#define MASK_x2 0b11111111
#define MASK_x3 0b111111111111
#define MASK_x4 0b1111111111111111

#define MK_MASK(BLU, RED)     ( (((BLU == HIGH) << 1) | (RED == HIGH)) << 2 )
#define LAST_MASK(SEQ)        ( SEQ & 0b1111 )
#define SEQ_MATCH(SEQ, MASK)  ( LAST_MASK(SEQ) == MASK )
#define SEQ_PUSH(SEQ, MASK)   ( (SEQ << MASK_WIDTH) | MASK )
#define SEQ_CLEAR_HOLD_BIT(SEQ)  ( SEQ & ~0b1 )
