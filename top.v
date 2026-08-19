module dsp_top(A, B, D, BCIN, C, PCIN, OPMODE, CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEM ,CEP, CEC, CED, CECARRYIN, CEOPMODE, BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";

input [17:0] A, B, D, BCIN;
input [47:0] C, PCIN;
input [7:0] OPMODE;
input CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEM ,CEP, CEC, CED, CECARRYIN, CEOPMODE;
output [17:0] BCOUT;
output [47:0] PCOUT, P;
output [35:0] M;
output CARRYOUT, CARRYOUTF;
wire [1:0] REG_01, REG_23, MUX_01, MUX_23;
wire REG_4, REG_5, REG_6, REG_7, MUX_4, MUX_5, MUX_6, MUX_7, CC_MUX, CYI_OUT, CIN, PRE_CARRYO, CYO_OUT;
wire [17:0] D_REG, B0_REG, A0_REG, D_MUX, B0_MUX, A0_MUX, PAS_OUT, PAS_MUX, B1_REG, B1_MUX, A1_REG, A1_MUX, BMUX;
wire [47:0] C_REG, C_MUX, ZMUX_OUT, XMUX_OUT, SUM, P_REG, P_MUX;
wire [35:0] MUL_OUT, M_REG, M_OUT;
wire [48:0] PAS2;

//OPMODES registers
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(2)) op01 (.D(OPMODE[1:0]), .CLK(CLK), .RST(RSTOPMODE), .Q(REG_01), .CE(CEOPMODE), .out_dffmux(MUX_01), .sel(OPMODEREG));
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(2)) op23 (.D(OPMODE[3:2]), .CLK(CLK), .RST(RSTOPMODE), .Q(REG_23), .CE(CEOPMODE), .out_dffmux(MUX_23), .sel(OPMODEREG));
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(1)) op4 (.D(OPMODE[4]), .CLK(CLK), .RST(RSTOPMODE), .Q(REG_4), .CE(CEOPMODE), .out_dffmux(MUX_4), .sel(OPMODEREG));
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(1)) op5 (.D(OPMODE[5]), .CLK(CLK), .RST(RSTOPMODE), .Q(REG_5), .CE(CEOPMODE), .out_dffmux(MUX_5), .sel(OPMODEREG));
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(1)) op6 (.D(OPMODE[6]), .CLK(CLK), .RST(RSTOPMODE), .Q(REG_6), .CE(CEOPMODE), .out_dffmux(MUX_6), .sel(OPMODEREG));
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(1)) op7 (.D(OPMODE[7]), .CLK(CLK), .RST(RSTOPMODE), .Q(REG_7), .CE(CEOPMODE), .out_dffmux(MUX_7), .sel(OPMODEREG));

//Stage 1 registers
dff_mux #(.RSTTYPE(RSTTYPE)) DM_D (.D(D), .CLK(CLK), .RST(RSTD), .Q(D_REG), .CE(CED), .out_dffmux(D_MUX), .sel(DREG));
assign BMUX = (B_INPUT == "DIRECT")? B : (B_INPUT == "CASCADE")? BCIN : 0;
dff_mux #(.RSTTYPE(RSTTYPE)) DM_B0 (.D(BMUX), .CLK(CLK), .RST(RSTB), .Q(B0_REG), .CE(CEB), .out_dffmux(B0_MUX), .sel(B0REG));
dff_mux #(.RSTTYPE(RSTTYPE)) DM_A0 (.D(A), .CLK(CLK), .RST(RSTA), .Q(A0_REG), .CE(CEA), .out_dffmux(A0_MUX), .sel(A0REG));
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(48)) DM_C (.D(C), .CLK(CLK), .RST(RSTC), .Q(C_REG), .CE(CEC), .out_dffmux(C_MUX), .sel(CREG));

//PAS1 + MUX
assign PAS_OUT = (MUX_6 == 1)? (D_MUX - B0_MUX) : (D_MUX + B0_MUX);
assign PAS_MUX = (MUX_4 == 1)? PAS_OUT : B0_MUX;

//B1
dff_mux #(.RSTTYPE(RSTTYPE)) DM_B1 (.D(PAS_MUX), .CLK(CLK), .RST(RSTB), .Q(B1_REG), .CE(CEB), .out_dffmux(B1_MUX), .sel(B1REG));

//A1
dff_mux #(.RSTTYPE(RSTTYPE)) DM_A1 (.D(A0_MUX), .CLK(CLK), .RST(RSTA), .Q(A1_REG), .CE(CEA), .out_dffmux(A1_MUX), .sel(A1REG));

assign BCOUT = B1_MUX;

//Multiplier stage
assign MUL_OUT = B1_MUX * A1_MUX;
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(36)) DM_M (.D(MUL_OUT), .CLK(CLK), .RST(RSTM), .Q(M_REG), .CE(CEM), .out_dffmux(M_OUT), .sel(MREG));

//Buffer
genvar i;
generate
    for (i = 0; i < 36; i=i+1) begin : MBUF
        buf MBUFF (M[i], M_OUT[i]);
    end
endgenerate

//X MUX
mux4x1 X (.I0(48'b0), .I1({12'b0, M_OUT}), .I2(P_MUX), .I3({D_MUX[11:0], A1_MUX, B1_MUX}), .op(MUX_01), .out_mux4x1(XMUX_OUT));

//Z MUX
mux4x1 Z (.I0(48'b0), .I1(PCIN), .I2(P_MUX), .I3(C_MUX), .op(MUX_23), .out_mux4x1(ZMUX_OUT));

//CIN
assign CC_MUX = (CARRYINSEL == "OPMODE5")? MUX_5 : (CARRYINSEL == "CARRYIN")? CARRYIN : 0;
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(1)) CYI (.D(CC_MUX), .CLK(CLK), .RST(RSTCARRYIN), .Q(CYI_OUT), .CE(CECARRYIN), .out_dffmux(CIN), .sel(CARRYINREG));

//PAS 2 STAGE
assign PAS2 = (MUX_7 == 1) ? ({1'b0, ZMUX_OUT} - ({1'b0, XMUX_OUT} + CIN)) : ({1'b0, ZMUX_OUT} + {1'b0, XMUX_OUT} + CIN);
assign SUM = PAS2[47:0];
assign PRE_CARRYO = PAS2[48];

//CARRYO
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(1)) CYO (.D(PRE_CARRYO), .CLK(CLK), .RST(RSTCARRYIN), .Q(CYO_OUT), .CE(CECARRYIN), .out_dffmux(CARRYOUT), .sel(CARRYOUTREG));
assign CARRYOUTF = CARRYOUT;

//P
dff_mux #(.RSTTYPE(RSTTYPE), .SIZE(48)) PFFMUX (.D(SUM), .CLK(CLK), .RST(RSTP), .Q(P_REG), .CE(CEP), .out_dffmux(P_MUX), .sel(PREG));
assign P = P_MUX;
assign PCOUT = P_MUX;

endmodule