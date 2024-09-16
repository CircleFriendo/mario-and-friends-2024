;;@name Player graphics
;;@author CircleFriendo


incsrc "../../shared/freeram.asm"
incsrc "../../shared/characters.asm"

!ReplaceExtendedTiles = 1




header
if read1($00FFD5) == $23
sa1rom
!addr = $6000
else
lorom
!addr = $0000
endif

!RAM_MarioPowerUp = $19
!MarioFrame = $13E0
!RAM_FrameCounter = $13
!TilesetIndex = $DF16
!TileExpansion = $DF1A
!Mario8x8Tiles = $DFDA
!CapePhase = $1407


;;; hijack at A304 instead of A300 for Retry compatibility
org $00A304
    autoclean JML MarioGFXDMA


freecode
prot MarioPalette
prot MarioGfx,LuigiGfx,DaisyGfx,PeachGfx,WarioGfx,WaluigiGfx
 


ChooseCharacter:
    LDA !player
    ASL A : TAX
    JMP.w (Players, X)

Players:
    dw Mario
    dw Luigi
    dw Peach
    dw Daisy
    dw Wario
    dw Waluigi

Mario:
    LDA.B #MarioGfx     :    STA   $03
    LDA.b #MarioGfx>>8  :    STA   $04
    LDA.b #MarioGfx>>16 :    STA   $05
	
    LDA.B #MarioPalette     :    STA   $06
    LDA.b #MarioPalette>>8  :    STA   $07
    LDA.b #MarioPalette>>16 :    STA   $08
	
    LDA.B #MarioOWPalette     :    STA   $09
    LDA.b #MarioOWPalette>>8  :    STA   $0A
    LDA.b #MarioOWPalette>>16 :    STA   $0B
	
    LDA $19
    CMP #$03
    BNE +
    
    LDA.B #MarioFirePalette     :    STA   $06
    LDA.b #MarioFirePalette>>8  :    STA   $07
    LDA.b #MarioFirePalette>>16 :    STA   $08
    
	+ RTS
	
Luigi:
    LDA.B #LuigiGfx     :    STA   $03 
    LDA.b #LuigiGfx>>8  :    STA   $04
    LDA.b #LuigiGfx>>16 :    STA   $05
	
    LDA.B #LuigiPalette     :    STA   $06
    LDA.b #LuigiPalette>>8  :    STA   $07
    LDA.b #LuigiPalette>>16 :    STA   $08
	
    LDA.B #LuigiOWPalette     :    STA   $09
    LDA.b #LuigiOWPalette>>8  :    STA   $0A
    LDA.b #LuigiOWPalette>>16 :    STA   $0B
	
    LDA $19
    CMP #$03
    BNE +
    
    LDA.B #LuigiFirePalette     :    STA   $06
    LDA.b #LuigiFirePalette>>8  :    STA   $07
    LDA.b #LuigiFirePalette>>16 :    STA   $08
    
    + RTS
	
Peach:
    LDA.B #PeachGfx     :    STA   $03
    LDA.b #PeachGfx>>8  :    STA   $04
    LDA.b #PeachGfx>>16 :    STA   $05
	
    LDA.B #PeachPalette     :    STA   $06
    LDA.b #PeachPalette>>8  :    STA   $07
    LDA.b #PeachPalette>>16 :    STA   $08
	
    LDA.B #PeachOWPalette     :    STA   $09
    LDA.b #PeachOWPalette>>8  :    STA   $0A
    LDA.b #PeachOWPalette>>16 :    STA   $0B
	
    LDA $19
    CMP #$03
    BNE +
    
    LDA.B #PeachFirePalette     :    STA   $06
    LDA.b #PeachFirePalette>>8  :    STA   $07
    LDA.b #PeachFirePalette>>16 :    STA   $08
    
    + RTS

Daisy:
    LDA.B #DaisyGfx     :    STA   $03
    LDA.b #DaisyGfx>>8  :    STA   $04
    LDA.b #DaisyGfx>>16 :    STA   $05
    
    LDA.B #DaisyPalette     :    STA   $06
    LDA.b #DaisyPalette>>8  :    STA   $07
    LDA.b #DaisyPalette>>16 :    STA   $08
	
    LDA.B #DaisyOWPalette     :    STA   $09
    LDA.b #DaisyOWPalette>>8  :    STA   $0A
    LDA.b #DaisyOWPalette>>16 :    STA   $0B
	
    LDA $19
    CMP #$03
    BNE +
    
    LDA.B #DaisyFirePalette     :    STA   $06
    LDA.b #DaisyFirePalette>>8  :    STA   $07
    LDA.b #DaisyFirePalette>>16 :    STA   $08
    
	+ RTS

Wario:
    LDA.B #WarioGfx     :    STA   $03
    LDA.b #WarioGfx>>8  :    STA   $04
    LDA.b #WarioGfx>>16 :    STA   $05
	
    LDA.B #WarioPalette     :    STA   $06
    LDA.b #WarioPalette>>8  :    STA   $07
    LDA.b #WarioPalette>>16 :    STA   $08
	
    LDA.B #WarioOWPalette     :    STA   $09
    LDA.b #WarioOWPalette>>8  :    STA   $0A
    LDA.b #WarioOWPalette>>16 :    STA   $0B
	
    LDA $19
    CMP #$03
    BNE +
    
    LDA.B #WarioFirePalette     :    STA   $06
    LDA.b #WarioFirePalette>>8  :    STA   $07
    LDA.b #WarioFirePalette>>16 :    STA   $08
    
    + RTS

Waluigi:
    LDA.B #WaluigiGfx     :    STA   $03
    LDA.b #WaluigiGfx>>8  :    STA   $04
    LDA.b #WaluigiGfx>>16 :    STA   $05
	
    LDA.B #WaluigiPalette     :    STA   $06
    LDA.b #WaluigiPalette>>8  :    STA   $07
    LDA.b #WaluigiPalette>>16 :    STA   $08
    
    LDA.B #WaluigiOWPalette     :    STA   $09
    LDA.b #WaluigiOWPalette>>8  :    STA   $0A
    LDA.b #WaluigiOWPalette>>16 :    STA   $0B

    LDA $19
    CMP #$03
    BNE +
    
    LDA.B #WaluigiFirePalette     :    STA   $06
    LDA.b #WaluigiFirePalette>>8  :    STA   $07
    LDA.b #WaluigiFirePalette>>16 :    STA   $08
    
    +
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; transfer GFX00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ReplaceExtendedTiles:

    SEP #$20
    
    LDA !CapePhase  ;; when gliding, we need tiles 4A, 4B, 5A, 5B
    BEQ ++
    LDA #$4A
    BRA .go
    ++
    
    LDY !RAM_MarioPowerUp   ;; otherwise grab the tiles from the table
    LDA !MarioFrame
    CMP #$3D
    BCS ++
    ADC !TilesetIndex,y
    ++
    TAY
    LDA !TileExpansion,y
    TAY
    LDA !Mario8x8Tiles+2,y
    BMI +
    
.go
    TAX
    
    REP #$20
    
    LDY #$80
	STY $2115
	LDA #$1801
	STA $4320
    TXA
    ASL #4
    ORA #$6000
    STA $2116
    TXA
    ASL #5
    CLC : ADC $03 : ADC #$5D00
    
	STA $4322
	LDY $05
	STY $4324
	LDA #$0040     ; two tiles
	STA $4325
	LDY #$04
	STY $420B
    
    SEP #$20
    
    LDA #$5A   ;; if we just transferred Tile $4A, go back and transfer $5A as well
    CPX #$4A
    BEQ .go
    
    +
RTS


ReplaceOverworldTiles:
    
    REP #$30
    
    LDA $1F13
    ASL #4
    STA $00
    LDA !RAM_FrameCounter
    AND #$0018
    ORA $00
    TAX
    
    LDA $13D9              ;;; warp spin
    CMP #$000B
    BNE +
    LDA !RAM_FrameCounter
    AND #$000C
    LSR #2
    TAX
    LDA $04894B,x       ;;; warp spinning table
    AND #$00FF
    TAX
    +
    
    PHX
    
    LDA $0487CB,x        ;;; OW frames table
    AND #$00FE
    
    SEP #$10
    
    TAX
    
    STA $7f9edd
    
    
    LDY #$80
	STY $2115
	LDA #$1801
	STA $4320
	TXA 
    ASL #4
    ORA #$6000
    STA $2116
    TXA   
    ASL #5
    CLC : ADC $03 : ADC #$6D00
	STA $4322
	LDY $05
	STY $4324
	LDA #$0040
	STA $4325
	LDY #$04
	STY $420B
    
    REP #$30
    PLX
    
    
    LDA $0487CB+4,x        ;;; OW frames table
    AND #$00FE
    SEP #$10
    
    TAX
    
    LDY #$80
	STY $2115
	LDA #$1801
	STA $4320
	TXA ; SP01-0A
    ASL #4
    ORA #$6000
    STA $2116
    TXA   ; digit
    ASL #5
    CLC : ADC $03 : ADC #$6D00
	STA $4322
	LDY $05
	STY $4324
	LDA #$0040
	STA $4325
	LDY #$04
	STY $420B


RTS


ReplaceOverworldPalette:

LDX.B #$04                ; We're using DMA channel 2 
              
LDY.B #$A0                ; \ Set Address for CG-RAM Write to x86 
STY.W $2121               ; / ; Address for CG-RAM Write
LDA.W #$2200              
STA.W $4320               ; Parameters for DMA Transfer

LDA $09               ; \ Get location of palette  
STA.W $4322               ; / ; A Address (Low Byte)

LDY $0B              ; \Palette bank 
STY.W $4324               ; / ; A Address Bank

LDA.W #$0020              ; \ x20 bytes will be transferred 
STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
STX.W $420B               ; Transfer the colors ; Regular DMA Channel Enable


LDY.B #$80                ; \ Set VRAM Address Increment Value to x80 
STY.W $2115               ; / ; VRAM Address Increment Value
LDA.W #$1801              
STA.W $4320               ; Parameters for DMA Transfer
LDA.W #$67F0              
STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
LDA.W $0D99               
STA.W $4322               ; A Address (Low Byte)




LDY.B #$7E                ; \ Set bank to x7E 
STY.W $4324               ; / ; A Address Bank
LDA.W #$0020              ; \ x20 bytes will be transferred 
STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
STX.W $420B               ; Transfer ; Regular DMA Channel Enable
RTS


MarioGFXDMA:

SEP #$20
LDA $0100     ;; skip all this if on the file select menu
CMP #$08
BEQ +
CMP #$09
BEQ +
CMP #$0A
BEQ +
BRA ++
+ 
JML $00A38F
++

JSR ChooseCharacter

if !ReplaceExtendedTiles

    SEP #$20
    LDA $0100|!addr  ; game mode 14
	CMP #$14
    REP #$20
	BNE +
    
    JSR ReplaceExtendedTiles
    
    +
endif



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; transfer GFX10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SEP #$20
LDA $0100|!addr ; 
AND #$FC        ; game mode 0C-0E
CMP #$0C        ;
BNE +

LDA $1B9B|!addr    ;; yoshi intro sequence
ORA $141A|!addr
BNE +


LDA $13D9|!addr    ;; event is playing
CMP #$01
BEQ +

;REP #$20
JSR ReplaceOverworldTiles
JSR ReplaceOverworldPalette

+


REP #$20                  ; 16 bit A ; Accum (16 bit) 
LDX.B #$04                ; We're using DMA channel 2 
LDY.W $0D84               
BEQ CODE_00A328 

SEP #$20
LDA $0D9B
CMP #$C0
BNE +
LDA $1495
BEQ +
CMP #$40 
REP #$20
BNE CODE_00A328
+
REP #$20
;;;; Palette
          
LDY.B #$86                ; \ Set Address for CG-RAM Write to x86 
STY.W $2121               ; / ; Address for CG-RAM Write
LDA.W #$2200              
STA.W $4320               ; Parameters for DMA Transfer

LDA $06               ; \ Get location of palette from $0D82-$0D83 
STA.W $4322               ; / ; A Address (Low Byte)

LDY $08                ; \Palette bank 
STY.W $4324               ; / ; A Address Bank

LDA.W #$0014              ; \ x14 bytes will be transferred 
STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
STX.W $420B               ; Transfer the colors ; Regular DMA Channel Enable

;;;; tile 7F?

CODE_00A328:
LDY.B #$80                ; \ Set VRAM Address Increment Value to x80 
STY.W $2115               ; / ; VRAM Address Increment Value
LDA.W #$1801              
STA.W $4320               ; Parameters for DMA Transfer
LDA.W #$67F0              
STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
LDA.W $0D99               
STA.W $4322               ; A Address (Low Byte)

LDY.B #$7E                ; \ Set bank to x7E 
STY.W $4324               ; / ; A Address Bank
LDA.W #$0020              ; \ x20 bytes will be transferred 
STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
STX.W $420B               ; Transfer ; Regular DMA Channel Enable

;;; top tiles


LDA.W #$6000              ; \ Set Address for VRAM Read/Write to x6000 
STA.W $2116               ; / ; Address for VRAM Read/Write (Low Byte)
LDX.B #$00  


CODE_00A355:
              
LDA.W $0D85,X             ; \ Get address of graphics to copy 

LDY.B #$7E                ; \ Set bank to x7E 
STY.W $4324               ; / ; A Address Bank

CPX #$06
BPL +
LDY.B $05               ; \ Set bank to x7E 
STY.W $4324               ; / ; A Address Bank

SEC
SBC #$2000
CLC
ADC $03

+ STA.W $4322               ; / ; A Address (Low Byte)

LDA.W #$0040              ; \ x40 bytes will be transferred 
STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
LDY.B #$04                ; \ Transfer 
STY.W $420B               ; / ; Regular DMA Channel Enable
INX                       ; \ Move to next address 
INX                       ; /  
CPX.W $0D84               ; \ Repeat last segment while X<$0D84 
BCC CODE_00A355           ; /  

;;; bottom tiles

LDA.W #$6100              ; \ Set Address for VRAM Read/Write to x6100 
STA.W $2116               ; / ; Address for VRAM Read/Write (Low Byte)
LDX.B #$00 

CODE_00A375:
               
LDA.W $0D8F,X             ; \ Get address of graphics to copy 
LDY.B #$7E                ; \ Set bank to x7E 
STY.W $4324               ; / ; A Address Bank

CPX #$06
BPL +
LDY.B $05                ; \ Set bank to x7E 
STY.W $4324               ; / ; A Address Bank

SEC
SBC #$2000
CLC
ADC $03
+ STA.W $4322               ; / ; A Address (Low Byte)

LDA.W #$0040              ; \ x40 bytes will be transferred 
STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
LDY.B #$04                ; \ Transfer 
STY.W $420B               ; / ; Regular DMA Channel Enable
INX                       ; \ Move to next address 
INX                       ; /  
CPX.W $0D84               ; \ Repeat last segment while X<$0D84 
BCC CODE_00A375           ; /  



SEP #$20                  ; 8 bit A ; Accum (8 bit) 
JML $00A38F



freedata
 
MarioPalette:
    dw $635F, $581D, $000A, $391F, $44C4, $4E08, $6770, $30B6, $35DF, $03FF
MarioFirePalette:
    dw $635F, $2DFC, $2529, $7FFF, $0008, $0017, $001F, $577B, $0DDF, $090D
MarioOWPalette:
    dw $0000, $7fff, $0000, $0016, $001F, $6D08, $2DDD, $635F
    dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000


LuigiPalette:
    dw $4F3F, $581D, $1140, $3FE0, $3C07, $7CAE, $7DB3, $2F00, $165F, $03FF
LuigiFirePalette:
    dw $3B1F, $581D, $2529, $7FFF, $1140, $01E0, $02E0, $577B, $0DDF, $03FF
LuigiOWPalette:
    dw $0000, $7fff, $0000, $0280, $03E0, $6D08, $261A, $573B
    dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000


PeachPalette:                      
    dw $635F, $45DF, $000A, $349E, $00CA, $05D7, $0EDF, $2455, $35DF, $54E3
PeachFirePalette:
    dw $635F, $739D, $110B, $52DC, $00AA, $0197, $027F, $41DF, $0DDF, $54E3
PeachOWPalette:
    dw $0000, $7fff, $0000, $0016, $001F, $6D08, $2DDD, $635F
    dw $2416, $349E, $01D7, $02DF, $0000, $0000, $0000, $0000


DaisyPalette:
    dw $575F, $029F, $14CF, $0118, $0886, $15DF, $2DDF, $1D55, $22E0, $3E34
DaisyFirePalette:
    dw $575F, $2DFC, $1111, $0007, $042B, $0017, $2DDF, $427B, $5D61, $3E34
DaisyOWPalette:
    dw $0000, $7fff, $0000, $15DF, $1199, $22E0, $14CF, $575F
    dw $10CA, $0000, $0000, $0000, $0000, $0000, $0000, $0000

WarioPalette:
    dw $635F, $581D, $0088, $03FF, $24AB, $4534, $59D8, $1A39, $35DF, $03FF
WarioFirePalette:
    dw $635F, $581D, $2529, $7FFF, $0088, $1A39, $03FF, $577B, $0DDF, $03FF
WarioOWPalette:
    dw $0000, $7FFF, $0000, $1A39, $03FF, $4534, $165F, $4F3F
    dw $581D, $0F7E, $11BD, $42DF, $0621, $0B0A, $7F60, $7FFF

WarioOldOWPalette:
    dw $0000, $0000, $4482, $700F, $785B, $381F, $0496, $1411
    dw $067E, $0F7E, $11BD, $42DF, $0621, $0B0A, $7f60, $7FFF

WaluigiPalette:
    dw $4F3F, $581D, $3C07, $7DB3, $2507, $356A, $49ED, $7CAE, $165F, $03FF
WaluigiFirePalette:
    dw $3B1F, $581D, $21CF, $739C, $3C07, $7CAE, $7DB3, $4F19, $0DDF, $03FF
WaluigiOWPalette:
    dw $0000, $7FFF, $0000, $3C07, $7DB3, $2507, $165F, $4F3F
    dw $581D, $0F7E, $11BD, $42DF, $0621, $0B0A, $7F60, $7FFF
    
    
freedata
MarioGfx:
	incbin gfx/Mario/GFX32.bin     ;5D00 bytes  -- player sprite
    incbin gfx/Mario/GFX00.bin     ;1000 bytes  -- extended tiles
    incbin gfx/Mario/GFX10.bin     ;1000 bytes  -- player OW sprite

freedata
LuigiGfx:
    incbin gfx/Luigi/GFX32.bin
    incbin gfx/Mario/GFX00.bin     ;use default
    incbin gfx/Luigi/GFX10.bin     
    
freedata
DaisyGfx:
    incbin gfx/Daisy/GFX32.bin
    incbin gfx/Daisy/GFX00.bin
    incbin gfx/Daisy/GFX10.bin
    
freedata
PeachGfx:
    incbin gfx/Peach/GFX32.bin
    incbin gfx/Peach/GFX00.bin
    incbin gfx/Peach/GFX10.bin
    
freedata
WarioGfx:
    incbin gfx/Wario/GFX32.bin
    incbin gfx/Mario/GFX00.bin     ;use default
    incbin gfx/Wario/GFX10.bin
    
    
freedata
WaluigiGfx:
    incbin gfx/Waluigi/GFX32.bin
    incbin gfx/Mario/GFX00.bin     ;use default
    incbin gfx/Waluigi/GFX10.bin
    
    