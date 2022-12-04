
`include "define.v"

module  risc_v_soc(
    input   wire            clk_100MHz  ,
    input   wire            arst_n      ,
    input   wire            hold           
);
    wire    [`MEM]          ram_r_data  ;
    wire    [`MEM]          rom_r_data  ;
    wire                    ram_r_ena   ;
    wire    [`MEM_ADDR]     ram_r_addr  ;
    wire                    ram_w_ena   ;
    wire    [`MEM_ADDR]     ram_w_addr  ;
    wire    [`MEM]          ram_w_data  ;
    wire    [`MEM_ADDR]     rom_r_addr  ;


    risc_v_pipe_top  u_risc_v_pipe_top (
        .clk_100MHz         ( clk_100MHz        ),
        .arst_n             ( arst_n            ),
        .hold               ( hold              ),
        .ram_r_data_i       ( ram_r_data        ),
        .rom_r_data_i       ( rom_r_data        ),
  
        .ram_r_ena_o        ( ram_r_ena         ),
        .ram_r_addr_o       ( ram_r_addr        ),
        .ram_w_ena_o        ( ram_w_ena         ),
        .ram_w_addr_o       ( ram_w_addr        ),
        .ram_w_data_o       ( ram_w_data        ),
        .rom_r_addr_i       ( rom_r_addr        )
    );

    ram u_ram(
        .clk_100MHz         ( clk_100MHz        ),
        .arst_n             ( arst_n            ),

        .rena_i             ( ram_r_ena         ),
        .raddr_i            ( ram_r_addr        ),
        .wena_i             ( ram_w_ena         ),
        .waddr_i            ( ram_w_addr        ),
        .wdata_i            ( ram_w_data        ),
        .rdata_o            ( ram_r_data        )
    );

    rom u_rom(
        .clk_100MHz         ( clk_100MHz        ),
        .arst_n             ( arst_n            ),

        .raddr_i            ( rom_r_addr        ),
        .rdata_o            ( rom_r_data        )
    );


endmodule
