module switch_level (
    input  clk,
    input  resetn,

    input  sw,          // switch
    output level        // level
);

debouncer sw_debouncer (
    .clk            (clk),
    .resetn         (resetn),
    .original_sig   (sw),
    .debounced_sig  (level)
);

endmodule
