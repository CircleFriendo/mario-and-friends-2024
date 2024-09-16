incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"



main:

    LDA $187A|!addr : BNE .Return
	LDA !scuttle : INC
	CMP #$0C : BNE +
	LDA #$00
+:
	STA !scuttle
	LDA $13E0|!addr
	CMP #$0B : BEQ .Jump
	CMP #$24 : BEQ .Jump
.Return:
	RTL
.Jump:
	LDX $19 : BEQ +
	LDX #$01
+:
	LDA !scuttle
	CMP #$03 : BCS +
	INX #$00 : BRA ++
+:
	CMP #$06 : BCS +
	INX #$02 : BRA ++
+:
	CMP #$09 : BCS +
	INX #$04 : BRA ++
+:
	INX #$06
++:
	LDA Table,x
	STA $13E0|!addr
	RTL

Table:
	db $00,$00,$00,$01,$01,$02,$01,$01