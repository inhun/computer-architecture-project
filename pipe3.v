module pipe3(
  input CLK,
  input wire [31:0] ALUresult,
  input wire [4:0] Wreg_addr,
  input wire RegWrite,
  input wire MemWrite,
  input wire MemRead,
  input wire MemtoReg,
  input wire JtoPC,
  input wire Branch,
  input wire PCSrc,
  input wire [31:0] Branch_or_offset,
  input wire [31:0] Branch_addr,
  input wire [31:0] jump_addr,
  input wire [31:0] DM_Write_data,
  input wire zero,
  input wire [31:0] next_PC,

  output reg [31:0] outALUresult,
  output reg [4:0] outWreg_addr,
  output reg outRegWrite,
  output reg outMemWrite,
  output reg outMemRead,
  output reg outMemtoReg,
  output reg outJtoPC,
  output reg outBranch,
  output reg outPCSrc,
  output reg [31:0] outBranch_or_offset,
  output reg [31:0] outBranch_addr,
  output reg [31:0] outjump_addr,
  output reg [31:0] outDM_Write_data,
  output reg outzero,
  output reg [31:0] outnext_PC
);



always @(negedge CLK)
begin
  outALUresult <= ALUresult;
  outWreg_addr <= Wreg_addr;
  outRegWrite <= RegWrite;
  outMemWrite <= MemWrite;
  outMemRead <= MemRead;
  outMemtoReg <= MemtoReg;
  outJtoPC <= JtoPC;
  outBranch <= Branch;
  outPCSrc <= PCSrc;
  outBranch_or_offset <= Branch_or_offset;
  outBranch_addr <= Branch_addr;
  outjump_addr <= jump_addr;
  outDM_Write_data <= DM_Write_data;
  outzero <= zero;
  outnext_PC <= next_PC;
end
initial
begin
  outPCSrc = 0;
end

endmodule
