incsrc ../../../../shared/freeram.asm

; act as 130

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP Return : JMP Return
JMP MarioCorner : JMP MarioBody : JMP MarioHead



MarioCorner:
MarioAbove:
	LDA !GroundPndTimer
	BNE ShatterIfBig

Turnblock:
	LDA #$1E
	STA $1693|!addr
	LDY #$01
	RTL

SpriteV:
	%check_sprite_kicked_vertical()
	bcs Shatter
	bra Turnblock
	
SpriteH:
	%check_sprite_kicked_horizontal()
	bcs Shatter
	bra Turnblock


MarioBelow:
	LDA !propeltimer
	BNE ShatterIfBig

MarioBody:
MarioHead:
MarioSide:
	LDA !DashTimer
	BNE ShatterIfBig
	BRA Solid


Shatter:
	%sprite_block_position()
	%shatter_block()
Return:
	rtl
Solid:
	LDA #$30 : STA $1693|!addr
	LDY #$01
	RTL
ShatterIfBig:
	LDA $19
	DEC
	BMI Solid
	%shatter_block()
	RTL



print "A block that shatters when a sprite is thrown at it."