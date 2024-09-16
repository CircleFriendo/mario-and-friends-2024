incsrc "../../../shared/freeram.asm"
incsrc "../../../shared/characters.asm"

main:
    
    LDA !player
    ASL A : TAX
    JMP.w (Players,X)

Players:
    dw Mario
    dw Luigi
    dw Peach
    dw Daisy
    dw Wario
    dw Waluigi



Mario:
    JSL names_mario
    RTL

Luigi:
    JSL names_luigi
    RTL

Daisy:
    JSL names_daisy
    RTL
    
Peach:
    JSL names_peach
    RTL
    
Wario:
    JSL names_wario
    RTL
    
Waluigi:
    JSL names_waluigi
    RTL