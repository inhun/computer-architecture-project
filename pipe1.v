module pipe1(
  input CLK,
  input wire [31:0] next_PC,
  input wire [31:0] instruct,
  input wire [5:0] Opcode,
  input wire [5:0] Funct,

  output reg [31:0] outnext_PC,
  output reg [31:0] outinstruct,
  output reg [5:0] outOpcode,
  output reg [5:0] outFunct
);


always @(negedge CLK)
begin
  outnext_PC <= next_PC;
  outinstruct <= instruct;
  outOpcode <= Opcode;
  outFunct <= Funct;
end

endmodule
