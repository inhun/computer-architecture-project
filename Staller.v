module Staller(
  input wire CLK,
  input wire [5:0] Opcode,
  input wire [4:0] Wreg_addr_two,
  input wire [4:0] Wreg_addr_three,
  input wire [4:0] Wreg_addr_four,
  input wire [4:0] Wreg_addr_five,

  input wire [4:0] Read1,
  input wire [4:0] Read2,

  input wire Branch_two,
  input wire Branch_three,
  input wire Branch_four,
  input wire Branch_five,

  input wire JToPC_two,
  input wire JToPC_three,

  output reg stall,
  output reg stall_J,
  output reg stall_B,
  output reg stall_RAW
);



always @ (posedge CLK)
begin
  stall_J <= 0;
  stall_B <= 0;
  stall_RAW <= 0;

  if (JToPC_two == 1)
    begin
      stall_J <= 1;
      stall_RAW <= 0;
    end
  if (JToPC_three == 1)
  begin
    stall_J <= 0;
    stall_RAW <= 0;
  end
  else if (Opcode == 6'b000000)
    begin
      if (Wreg_addr_five == Read1)
        stall_RAW <= 1;
      else if (Wreg_addr_three == Read1)
        stall_RAW <= 1;
      else if (Wreg_addr_four == Read1)
        stall_RAW <= 1;
      else if (Wreg_addr_five == Read2)
        stall_RAW <= 1;
      else if (Wreg_addr_three == Read2)
        stall_RAW <= 1;
      else if (Wreg_addr_four == Read2)
        stall_RAW <= 1;
    end
  else if (Opcode != 6'b101011)
  begin
    if (Wreg_addr_three == Read1)
      stall_RAW <= 1;
    else if (Wreg_addr_four == Read1)
      stall_RAW <= 1;
    else if (Wreg_addr_five == Read1)
      stall_RAW <= 1;
  end
  /*
    begin
      if (Wreg_addr_two == Read1)
        stall_RAW <= 1;
        stall_B <= 0;
        stall_J <= 0;
      else if (Wreg_addr_three == Read1)
        stall_RAW <= 1;
      else if (Wreg_addr_four == Read1)
        stall_RAW <= 1;
    end
  */

  if (Branch_two || Branch_three || Branch_four)
  begin
    stall_B <= 1;
    stall_RAW <= 0;
  end
  if (Branch_five == 1)
  begin
    stall_B <= 0;
    stall_RAW <= 0;
  end


  // stall <= (stall_J || stall_B  || stall_RAW);
end


initial
begin
  stall <= 0;

end

endmodule
