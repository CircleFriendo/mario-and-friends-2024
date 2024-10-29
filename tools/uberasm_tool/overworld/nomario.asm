incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"

init:
    LDA !player : CMP #!mario : BNE +
    INC : STA !player
    + RTL