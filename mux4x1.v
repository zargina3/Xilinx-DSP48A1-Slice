module mux4x1(I0, I1, I2, I3, op, out_mux4x1);
input [47:0] I0, I1, I2, I3;
input [1:0] op;
output [47:0] out_mux4x1;

assign out_mux4x1 = (op == 2'b00)? I0 : (op == 2'b01)? I1 : (op == 2'b10)? I2 : I3;

endmodule