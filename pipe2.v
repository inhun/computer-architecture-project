module pipe2(
  input CLK,
  input wire [31:0] Rdata1,
  input wire [31:0] Rdata2,
  input wire [4:0] Wreg_addr,
  input wire [31:0] next_PC,
  input wire [31:0] Branch_or_offset,
  input wire RegWrite,
  input wire ALUSrc,
  input wire MemWrite,
  input wire MemRead,
  input wire MemtoReg,
  input wire JToPC,
  input wire Branch,
  input wire [3:0] ALUOp,
  input wire [5:0] Opcode,
  input wire [31:0] instruct,

  output reg [31:0] outRdata1,
  output reg [31:0] outRdata2,
  output reg [4:0] outWreg_addr,
  output reg [31:0] outnext_PC,
  output reg [31:0] outBranch_or_offset,
  output reg outRegWrite,
  output reg outALUSrc,
  output reg outMemWrite,
  output reg outMemRead,
  output reg outMemtoReg,
  output reg outJToPC,
  output reg outBranch,
  output reg [3:0] outALUOp,
  output reg [5:0] outOpcode,
  output reg [31:0] outinstruct
);


always @(negedge CLK)
begin
  outRdata1 <= Rdata1;
  outRdata2 <= Rdata2;
  outWreg_addr <= Wreg_addr;
  outnext_PC <= next_PC;
  outRegWrite <= RegWrite;
  outALUSrc <= ALUSrc;
  outMemWrite <= MemWrite;
  outMemRead <= MemRead;
  outMemtoReg <= MemtoReg;
  outJToPC <= JToPC;
  outBranch <= Branch;
  outALUOp <= ALUOp;
  outBranch_or_offset <= Branch_or_offset;
  outOpcode <= Opcode;
  outinstruct <= instruct;
end

endmodule
