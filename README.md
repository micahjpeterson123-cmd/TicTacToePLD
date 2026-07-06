# Tic-Tac-Toe FPGA State Machine (Verilog)

A Verilog implementation of a two-player Tic-Tac-Toe game as a finite state
machine, designed to run on an FPGA and interface with an external "logic
board" I/O bus (buttons/switches in, a 3x3 grid of red/blue cell LEDs wired
off-board that represent actual player moves, and onboard RGB LEDs used only
for debugging FSM state).

## Overview

The design (`tictactoefinal.v`) is a single Moore-style FSM (`tictactoefinal`)
that:

- Divides an incoming 66 MHz clock down to a slower toggling clock (`clk_out`)
  used to pace game-state transitions.
- Reads player input from two 8-bit input buses (`LB_AD`, `LB_IOH`), which
  together provide 9 discrete "cell select" lines corresponding to the 9
  squares of the tic-tac-toe board.
- Writes cell ownership out across three 8-bit output buses (`LB_XIOH`,
  `LB_XIOLA`, `LB_COMM`), with each square having a dedicated "red" bit and
  "blue" bit (18 signals total for 9 squares x 2 players).
- Drives 4 onboard RGB LEDs (`LED_1` through `LED_4`) purely as **debug
  indicators** showing which FSM state the board is currently in — they do
  not represent player/cell ownership.
- Drives a set of transceiver direction/output-enable control lines
  (`TR_DIR_1..5`, `TR_OE_1..5`), presumably for bus buffers/level shifters
  sitting between the FPGA and the external logic board headers.

## Hardware I/O Summary

| Signal(s)                          | Direction | Purpose                                  |
|-------------------------------------|-----------|-------------------------------------------|
| `CLK_66MHz`                          | in        | Master clock input                        |
| `LED_1..4_{RED,GREEN,BLUE}`          | out       | Onboard RGB debug LEDs — indicate current FSM state, not player/cell data (active-low: `0` = lit) |
| `TR_DIR_1..5`, `TR_OE_1..5`           | out       | Bus transceiver direction / output-enable |
| `LB_AD[7:0]`                          | in        | Player input bus (cell select, group A)   |
| `LB_IOH[7:0]`                         | in        | Player input bus (cell select, group B)   |
| `LB_COMM[7:0]`                        | out       | Cell state output (2 of 9 squares)        |
| `LB_XIOH[7:0]`, `LB_XIOLA[7:0]`       | out       | Cell state output (remaining squares)     |
| `clk_out`                             | out       | Divided-down clock, toggled per game tick |

These bus bits are hardwired to an external 3x3 array of red/blue LEDs off
the main board — this is where player/cell ownership is actually visible,
not the onboard `LED_1..4` RGB indicators. Cell mapping (squares labeled
`a`–`i`) is split across the three output buses as commented in the source:

```
ra, rb, rc, rd, re, rf, rg, rh, ri   -> "red" occupancy per square
ba, bb, bc, bd, be, bf, bg, bh, bi   -> "blue" occupancy per square
```

## Clock Divider

```verilog
parameter DIVISOR = 28'd66000000;
```

`clk_increment` counts 66,000,000 `CLK_66MHz` ticks (~1 second at 66 MHz)
before `clk_out` toggles and the FSM is allowed to advance. This is also the
point at which a "reset" check occurs: if `LB_AD[7]` is asserted, all cell
outputs clear and the FSM returns to state `A`.

## State Machine

12 states are defined (`A` through `K`, 4-bit encoded), grouped into three
phases:

- **A → D**: Players select one of the 9 cells via
  `LB_AD`/`LB_IOH`; the corresponding color bit is latched and the FSM
  advances one state per selection, alternating red/blue to differentiate both players.
- **E → I**: After each selection the FSM detours through state
  J/K to check for a win before returning to continue the E→F→G→H→I
  sequence (tracked via prevstate).
- **J / K**: Win-check states. Each evaluates the 8 standard tic-tac-toe
  winning lines against the latched "red" bits (state J) or "blue" bits
  (state K). On a win, all 9 cell bits for both colors alternate on and off to
  create a celebratory light show. If no win is found, the FSM falls back to state A.
  
default: curstate <= A; guards against an undefined state value.
