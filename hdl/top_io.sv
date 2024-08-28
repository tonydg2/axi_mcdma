module top_io (
    output [1:0]    RADIO_LED
);
///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .clk100       (clk100       ),
    .rstn         (rstn         ),
    .led_div_i    ('0           ),
    .led_o        (RADIO_LED[0] ),
    .led_wren_i   ('0           )
  );

  led_cnt led_cnt_inst (
    .rst    (~rstn        ),
    .clk100 (clk100       ),
    .div_i  (5'h1         ),
    .wren_i ('0           ),
    .led_o  (RADIO_LED[1] )
  );


endmodule