; act as 25

incsrc "../../../../shared/freeram.asm"
incsrc "../../../../shared/characters.asm"

db $42
JMP Touch : JMP Touch : JMP Touch
JMP Return : JMP Return : JMP Return : JMP Return
JMP Touch : JMP Touch : JMP Touch

Touch:
    LDA #!waluigi : STA !player
Return:
    RTL

print "Change player to Waluigi."