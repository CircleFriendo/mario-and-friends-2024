

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
    BRA dragoncoins

org $008FD8
dragoncoins: