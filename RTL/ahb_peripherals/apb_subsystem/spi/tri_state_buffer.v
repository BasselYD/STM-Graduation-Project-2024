module tri_state_buffer
(
  input  wire        enable,
  input  wire        data_in,
  output tri         data_out
);

assign data_out = enable ? data_in : 1'bz ;

endmodule
