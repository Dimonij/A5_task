module A5_task_top

#( parameter WIDTH = 12 )

(
  input  logic                      clk_i, srst_i,

  input  logic  [WIDTH-1:0] data_i,

  output logic [WIDTH-1:0] data_o_left,
  output logic [WIDTH-1:0] data_o_right
);

logic [WIDTH-1:0] data_o_left_buf;     //output  data   buffer
logic [WIDTH-1:0] data_o_right_buf;   //output  data   buffer
logic [WIDTH-1:0] data_i_buf;             //input   data   buffer
logic                     srst_i_buf;

// port mapping
A5_task #( WIDTH ) A5_core_unit
(
  .clk_i              ( clk_i ),
  .srst_i             ( srst_i_buf ),
  .data_i            ( data_i_buf ),
  .data_o_left    ( data_o_left_buf ),
  .data_o_right  ( data_o_right_buf)
);

//data locking
always_ff @( posedge clk_i )
  begin
   srst_i_buf         <= srst_i;
   data_i_buf        <= data_i;
  
   data_o_left       <= data_o_left_buf;
   data_o_right     <= data_o_right_buf;
  end

endmodule
