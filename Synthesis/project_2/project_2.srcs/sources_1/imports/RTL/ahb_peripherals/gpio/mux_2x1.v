module mux_2x1 (
  input A , B ,
  input Sel,
  output reg C
  );
  
always@(*)
begin
  case(Sel)
    1'b0 : C = A;
    1'b1:  C = B;
  endcase
end

endmodule
