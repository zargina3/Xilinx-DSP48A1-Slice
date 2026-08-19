module dff_mux(D, CLK, RST, Q, CE, out_dffmux, sel);
parameter SIZE = 18;
parameter RSTTYPE = "SYNC";
input [SIZE-1:0] D;
input CLK, RST, CE, sel;
output reg [SIZE-1:0] Q;
output [SIZE-1:0] out_dffmux;

generate
    if (RSTTYPE == "ASYNC") begin
        always @(posedge CLK or posedge RST) begin
            if (RST)
            Q <= 0;
            else if (CE)
            Q <= D;
        end
    end
    else begin
        always @(posedge CLK) begin
            if (RST)
            Q <= 0;
            else if (CE)
            Q <= D;
        end
    end
endgenerate

assign out_dffmux = (sel == 1)? Q : D;

endmodule