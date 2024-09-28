incsrc "../../../shared/freeram.asm"

load:
    LDA !store_rng_freeram : STA $148B|!addr
    RTL

main:
    REP #$20
    LDA $148B|!addr : STA !store_rng_freeram
    SEP #$20
    RTL
