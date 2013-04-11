/* http://codegolf.stackexchange.com/q/6693/134
 * reference implementation
 * by user FUZxxl
 * Minor changes by Jason Knight to use existing board data.
 * Does not work very well. Not shown in final product.
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "PlayerFlag.h"
#define MAXBOARD 256

/* bit 0x01: black colour
 * bit 0x02: white colour
 * bit 0x04: there is a stone on the intersection
 */

enum colour {
	UNCOLOURED    = 0x0,
	BLACK_REACHED = 0x1,
	WHITE_REACHED = 0x2,
	BOTH_REACHED  = 0x3,
	HAS_STONE     = 0x4,
	BLACK         = 0x5,
	WHITE         = 0x6
};

static enum colour board[MAXBOARD*MAXBOARD] = { 0 };

static int bsize = 0;

static int score_input(char*);
static void fill_board(void);

static int score_input(char* board_input) {
	int n = 0;
	int invalue;
    bsize = 0;
	while ((invalue = board_input[n]) != '\0') {
		switch (invalue) {
			case P_UNDEFINED: board[n++] = UNCOLOURED; break;
			case P_BLACK: board[n++] = BLACK; break;
			case P_WHITE: board[n++] = WHITE; break;
		}
	}

	while (bsize*bsize < n) bsize++;

	/* your program may exhibit undefined behavior if this is true */
	if (bsize*bsize != n) return -99999999;
    
    fill_board();
    
    int w = 0, b = 0;
    
	for (n = 0; n < bsize*bsize; ++n) switch (board[n] & ~HAS_STONE) {
		case BLACK_REACHED: ++b; break;
		case WHITE_REACHED: ++w; break;
	}
    return b-w;
}

static void fill_board(void) {
	int i,j;
	bool changes;
	enum colour here, top, bottom, left, right, accum;

	do {
		changes = false;

		for (i = 0; i < bsize; ++i) {
			for (j = 0; j < bsize; ++j) {

				here   = board[i*bsize+j];
				if (here >= BOTH_REACHED) continue;

				top    = i == 0 ? UNCOLOURED : board[(i-1)*bsize+j];
				left   = j == 0 ? UNCOLOURED : board[i*bsize+j-1];
				bottom = i == bsize-1 ? UNCOLOURED : board[(i+1)*bsize+j];
				right  = j == bsize-1 ? UNCOLOURED : board[i*bsize+j+1];

				accum = here | top | bottom | left | right;
				accum &= ~HAS_STONE;

				changes |= board[i*bsize+j] != accum;

				board[i*bsize+j] = accum;

			}
		}

	} while (changes);
}
