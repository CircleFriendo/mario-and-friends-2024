incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"


init:
    ; Set default character to mario
    LDA #!mario : STA !player : STA !lastplayer

    ; Initialize physics tables
    JSL physicstables_default
    
    RTL
