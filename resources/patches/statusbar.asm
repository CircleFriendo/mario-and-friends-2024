
; move timer
org $008E6F
    LDA $0F31
    STA $0F0A
    LDA $0F32
    STA $0F0B
    LDA $0F33
    STA $0F0C


; skip score
org $008EC6
    BRA coins
    
org $008F1D
coins:


; skip lives
org $008F49
    BRA displaycoins

org $008F73
displaycoins:



; skip bonus stars and name
org $008F86
    JSR $9079
    BRA dragoncoins


org $008FD8
dragoncoins: