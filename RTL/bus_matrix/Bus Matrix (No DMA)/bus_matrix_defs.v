// -----------------------------------------------------------------------------
// Constant declarations
// Bus matrix constant declaration
// -----------------------------------------------------------------------------
// HTRANS transfer type signal encoding
`define TRN_IDLE   2'b00       // Idle transfer
`define TRN_BUSY   2'b01       // Busy transfer
`define TRN_NONSEQ 2'b10       // NonSequential transfer
`define TRN_SEQ    2'b11       // Sequential transfer

// HBURST transfer type signal encoding
`define BUR_SINGLE 3'b000       // Single
`define BUR_INCR   3'b001       // Incremental
`define BUR_WRAP4  3'b010       // 4-beat wrap
`define BUR_INCR4  3'b011       // 4-beat Incr
`define BUR_WRAP8  3'b100       // 8-beat wrap
`define BUR_INCR8  3'b101       // 8-beat Incr
`define BUR_WRAP16 3'b110       // 16-beat Wrap
`define BUR_INCR16 3'b111       // 16-beat Incr