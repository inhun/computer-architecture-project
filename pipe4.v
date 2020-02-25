module pipe4(
  input CLK,
  input wire [31:0] MemRdata,
  input wire [4:0] Wreg_addr,
  input wire RegWrite,
  input wire [31:0] ALU_result,
  input wire MemToReg,
  input wire Branch,

  output reg [31:0] outMemRdata,
  output reg [4:0] outWreg_addr,
  output reg outRegWrite,
  output reg [31:0] outALU_result,
  output reg outMemToReg,
  output reg outBranch
);

always @(negedge CLK)
begin
  outMemRdata <= MemRdata;
  outWreg_addr <= Wreg_addr;
  outRegWrite <= RegWrite;
  outALU_result <= ALU_result;
  outMemToReg <= MemToReg;
  outBranch <= Branch;
end

endmodule
