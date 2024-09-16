incsrc "../../../shared/freeram.asm"

!StatusName = $7e0ef9

mario:
    LDX #$04 ; 5 bytes
    - LDA MarioName,x
    STA !StatusName,x
    DEX
    BPL -
    RTL

luigi:
    LDX #$04 ; 5 bytes
    - LDA LuigiName,x
    STA !StatusName,x
    DEX
    BPL -
    RTL

daisy:
    LDX #$04 ; 5 bytes
    - LDA DaisyName,x
    STA !StatusName,x
    DEX
    BPL -
    RTL

peach:
    LDX #$04 ; 5 bytes
    - LDA PeachName,x
    STA !StatusName,x
    DEX
    BPL -
    RTL

wario:
    LDX #$04 ; 5 bytes
    - LDA WarioName,x
    STA !StatusName,x
    DEX
    BPL -
    RTL

waluigi:
    LDX #$04 ; 5 bytes
    - LDA WaluigiName,x
    STA !StatusName,x
    DEX
    BPL -
    RTL


color:
    JSR ChooseColor
    RTL

ChooseColor:
    LDA !player
    ASL A : TAX
    JMP.w (Players, X)

Players:
    dw Red
    dw Green
    dw Pink
    dw Orange
    dw Yellow
    dw Purple

Red:
    LDA #$0A : STA $2121
    LDA #$FB : STA $2122
    LDA #$0C : STA $2122
    RTS
Green:
    LDA #$0B : STA $2121
    LDA #$EB : STA $2122
    LDA #$2F : STA $2122
    RTS
Pink:
    LDA #$0A : STA $2121
    LDA #$5F : STA $2122
    LDA #$63 : STA $2122
    RTS
Orange:
    LDA #$0B : STA $2121
    LDA #$FF : STA $2122
    LDA #$01 : STA $2122
    RTS
Yellow:
    LDA #$0A : STA $2121
    LDA #$FF : STA $2122
    LDA #$03 : STA $2122
    RTS
Purple:
    LDA #$0B : STA $2121
    LDA #$12 : STA $2122
    LDA #$66 : STA $2122
    RTS

MarioName:
    ;; M   A   R   I   O
    db $30,$31,$32,$33,$34

LuigiName:
    ;; L   U   I   G   I
    db $40,$41,$42,$43,$44


PeachName:
    ;; P   E   A   C   H
    db $65,$66,$67,$68,$69

DaisyName:
    ;; D   A   I   S   Y
    db $55,$56,$57,$58,$59

WarioName:
    ;; W   A   R   I   O
    db $38,$39,$32,$33,$34

WaluigiName:
    ;; W   A   L   U   I   G   I
    db $48,$49,$40,$41,$42,$43,$44