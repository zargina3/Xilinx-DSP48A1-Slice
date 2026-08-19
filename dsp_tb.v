module dsp_tb();
reg [17:0] A_tb, B_tb, D_tb, BCIN_tb;
reg [47:0] C_tb, PCIN_tb;
reg [7:0] OPMODE_tb;
reg CLK_tb, CARRYIN_tb, RSTA_tb, RSTB_tb, RSTM_tb, RSTP_tb, RSTC_tb, RSTD_tb, RSTCARRYIN_tb, RSTOPMODE_tb, CEA_tb, CEB_tb, CEM_tb, CEP_tb, CEC_tb, CED_tb, CECARRYIN_tb, CEOPMODE_tb;
wire [17:0] BCOUT_DUT;
wire [47:0] PCOUT_DUT, P_DUT;
wire [35:0] M_DUT;
wire CARRYOUT_DUT, CARRYOUTF_DUT;

dsp_top DUT (A_tb, B_tb, D_tb, BCIN_tb, C_tb, PCIN_tb, OPMODE_tb, CLK_tb, CARRYIN_tb, RSTA_tb, RSTB_tb, RSTM_tb, RSTP_tb, RSTC_tb, RSTD_tb, RSTCARRYIN_tb, RSTOPMODE_tb, CEA_tb, CEB_tb, CEM_tb ,CEP_tb, CEC_tb, CED_tb, CECARRYIN_tb, CEOPMODE_tb, BCOUT_DUT, PCOUT_DUT, P_DUT, M_DUT, CARRYOUT_DUT, CARRYOUTF_DUT);

initial begin
     CLK_tb = 0;
     forever   
     #1 CLK_tb = ~CLK_tb;
end

integer i;
initial begin
//reset
    RSTA_tb = 1;
    RSTB_tb = 1;
    RSTM_tb = 1;
    RSTP_tb = 1;
    RSTC_tb = 1;
    RSTD_tb = 1;
    RSTCARRYIN_tb = 1;
    RSTOPMODE_tb = 1;
    A_tb = $random;
    B_tb = $random;
    D_tb = $random;
    BCIN_tb = $random;
    C_tb = $random;
    PCIN_tb = $random;
    OPMODE_tb = $random;
    CARRYIN_tb = $random;
    CEA_tb = $random;
    CEB_tb = $random;
    CEM_tb = $random;
    CEP_tb = $random;
    CEC_tb = $random;
    CED_tb = $random;
    CECARRYIN_tb = $random;
    CEOPMODE_tb = $random;
    @(negedge CLK_tb);
    if ((BCOUT_DUT == 0) && (PCOUT_DUT == 0) && (P_DUT == 0) && (M_DUT == 0) && (CARRYOUT_DUT == 0) && (CARRYOUTF_DUT == 0))
    $display("All outputs are zero");
    else 
    $display("Not all outputs are zero");

//Deassert & assert
    RSTA_tb = 0;
    RSTB_tb = 0;
    RSTM_tb = 0;
    RSTP_tb = 0;
    RSTC_tb = 0;
    RSTD_tb = 0;
    RSTCARRYIN_tb = 0;
    RSTOPMODE_tb = 0;
    CEA_tb = 1;
    CEB_tb = 1;
    CEM_tb = 1;
    CEP_tb = 1;
    CEC_tb = 1;
    CED_tb = 1;
    CECARRYIN_tb = 1;
    CEOPMODE_tb = 1;

//Path 1
    OPMODE_tb = 8'b11011101;
    A_tb = 'd20;
    B_tb = 'd10;
    C_tb = 'd350;
    D_tb = 'd25;
    BCIN_tb = $random;
    PCIN_tb = $random;
    CARRYIN_tb = $random;
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    if ((BCOUT_DUT == 'hf) && (PCOUT_DUT == 'h32) && (P_DUT == 'h32) && (M_DUT == 'h12c) && (CARRYOUT_DUT == 0) && (CARRYOUTF_DUT == 0))
    $display("Path 1 Pass");
    else
    $display("Path 1 Error");

//Path 2
    OPMODE_tb = 8'b00010000;
    A_tb = 'd20;
    B_tb = 'd10;
    C_tb = 'd350;
    D_tb = 'd25;
    BCIN_tb = $random;
    PCIN_tb = $random;
    CARRYIN_tb = $random;
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    if ((BCOUT_DUT == 'h23) && (PCOUT_DUT == 0) && (P_DUT == 0) && (M_DUT == 'h2bc) && (CARRYOUT_DUT == 0) && (CARRYOUTF_DUT == 0))
    $display("Path 2 Pass");
    else
    $display("Path 2 Error");

//Path 3
    OPMODE_tb = 8'b00001010;
    A_tb = 'd20;
    B_tb = 'd10;
    C_tb = 'd350;
    D_tb = 'd25;
    BCIN_tb = $random;
    PCIN_tb = $random;
    CARRYIN_tb = $random;
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    if ((BCOUT_DUT == 'ha) && (P_DUT == PCOUT_DUT) && (M_DUT == 'hc8) && (CARRYOUT_DUT == CARRYOUTF_DUT))
    $display("Path 3 Pass");
    else
    $display("Path 3 Error");

//Path 4
    OPMODE_tb = 8'b10100111;
    A_tb = 'd5;
    B_tb = 'd6;
    C_tb = 'd350;
    D_tb = 'd25;
    PCIN_tb = 'd3000;
    BCIN_tb = $random;
    CARRYIN_tb = $random;
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    @(negedge CLK_tb);
    if ((BCOUT_DUT == 'h6) && (PCOUT_DUT == 'hfe6fffec0bb1) && (P_DUT == 'hfe6fffec0bb1) && (M_DUT == 'h1e) && (CARRYOUT_DUT == 1) && (CARRYOUTF_DUT == 1))
    $display("Path 4 Pass");
    else
    $display("Path 4 Error");

end

endmodule