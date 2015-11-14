typedef unsigned int btn_mask;
typedef unsigned long tyme;

#define MASK_WIDTH 2

#define HOLD_DOWN_MASK 0b00
#define BLU_MASK       0b10
#define RED_MASK       0b01

#define MASK_BLU_POINT 0b0000000000000010
#define MASK_RED_POINT 0b0000000000000001
#define MASK_NEW_GAME1 0b0000000000111100
#define MASK_NEW_GAME2 0b0000000001111100
#define MASK_NEW_GAME3 0b0000000010111100
#define HOLD_DOWN_MILLIS 2000

#define MK_MASK(BLU, RED)     ( ((BLU == HIGH) << 1) | (RED == HIGH) )
#define LAST_MASK(SEQ)        ( SEQ & 0b11 )
#define SEQ_MATCH(SEQ, MASK)  ( LAST_MASK(SEQ) == MASK )
#define SEQ_PUSH(SEQ, MASK)   ( (SEQ << MASK_WIDTH) | MASK )
