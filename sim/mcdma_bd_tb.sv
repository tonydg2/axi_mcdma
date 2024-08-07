
`timescale 1ns / 1ps  // <time_unit>/<time_precision>
  // time_unit: measurement of delays / simulation time (#10 = 10<time_unit>)
  // time_precision: how delay values are rounded before being used in simulation (degree of accuracy of the time unit)

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

module mcdma_tb ;

  logic clk=0, rstn=0, rst;

  always #2 clk = ~clk; // 250mhz period = 4ns, invert every 2ns

  initial begin
    rstn <= 0;
    #20;
    rstn <= 1;
  end
  assign rst = !rstn;

  localparam AXIL_DWIDTH = 32;
  localparam DATA_WIDTH = 64;
  localparam ADDR_WIDTH = 40;
  localparam BD_DW = 128;

  logic  [39 : 0]   S00_axi_awaddr    ;    
  logic  [7 : 0]    S00_axi_awlen     ;  
  logic  [2 : 0]    S00_axi_awsize    ;    
  logic  [1 : 0]    S00_axi_awburst   ;    
  logic  [0 : 0]    S00_axi_awlock    ;    
  logic  [3 : 0]    S00_axi_awcache   ;    
  logic  [2 : 0]    S00_axi_awprot    ;    
  logic  [3 : 0]    S00_axi_awregion  ;      
  logic  [3 : 0]    S00_axi_awqos     ;  
  logic             S00_axi_awvalid   ;    
  logic             S00_axi_awready   ;    
  logic  [127 : 0]  S00_axi_wdata     ;  
  logic  [15 : 0]   S00_axi_wstrb     ;  
  logic             S00_axi_wlast     ;  
  logic             S00_axi_wvalid    ;    
  logic             S00_axi_wready    ;    
  logic [1 : 0]     S00_axi_bresp     ;  
  logic             S00_axi_bvalid    ;    
  logic             S00_axi_bready    ;    
  logic  [39 : 0]   S00_axi_araddr    ;    
  logic  [7 : 0]    S00_axi_arlen     ;  
  logic  [2 : 0]    S00_axi_arsize    ;    
  logic  [1 : 0]    S00_axi_arburst   ;    
  logic  [0 : 0]    S00_axi_arlock    ;    
  logic  [3 : 0]    S00_axi_arcache   ;    
  logic  [2 : 0]    S00_axi_arprot    ;    
  logic  [3 : 0]    S00_axi_arregion  ;      
  logic  [3 : 0]    S00_axi_arqos     ;  
  logic             S00_axi_arvalid   ;    
  logic             S00_axi_arready   ;    
  logic [127 : 0]   S00_axi_rdata     ;  
  logic [1 : 0]     S00_axi_rresp     ;  
  logic             S00_axi_rlast     ;  
  logic             S00_axi_rvalid    ;    
  logic             S00_axi_rready    ;    

  logic [ADDR_WIDTH-1 : 0]      m_axi_awaddr;
  logic [7 : 0]                 m_axi_awlen;
  logic [2 : 0]                 m_axi_awsize;
  logic [1 : 0]                 m_axi_awburst;
  logic [0 : 0]                 m_axi_awlock;
  logic [3 : 0]                 m_axi_awcache;
  logic [2 : 0]                 m_axi_awprot;
  logic [3 : 0]                 m_axi_awregion;
  logic [3 : 0]                 m_axi_awqos;
  logic                         m_axi_awvalid;
  logic                         m_axi_awready;
  logic [DATA_WIDTH-1 : 0]      m_axi_wdata;
  logic [(DATA_WIDTH/8)-1 : 0]  m_axi_wstrb;
  logic                         m_axi_wlast;
  logic                         m_axi_wvalid;
  logic                         m_axi_wready;
  logic [1 : 0]                 m_axi_bresp;
  logic                         m_axi_bvalid;
  logic                         m_axi_bready;
  logic [ADDR_WIDTH-1 : 0]      m_axi_araddr;
  logic [7 : 0]                 m_axi_arlen;
  logic [2 : 0]                 m_axi_arsize;
  logic [1 : 0]                 m_axi_arburst;
  logic [0 : 0]                 m_axi_arlock;
  logic [3 : 0]                 m_axi_arcache;
  logic [2 : 0]                 m_axi_arprot;
  logic [3 : 0]                 m_axi_arregion;
  logic [3 : 0]                 m_axi_arqos;
  logic                         m_axi_arvalid;
  logic                         m_axi_arready;
  logic [DATA_WIDTH-1 : 0]      m_axi_rdata;
  logic [1 : 0]                 m_axi_rresp;
  logic                         m_axi_rlast;
  logic                         m_axi_rvalid;
  logic                         m_axi_rready;


  logic [ADDR_WIDTH-1:0]      S_AXIL_araddr  =0   ;
  logic [2:0]                 S_AXIL_arprot       ;
  logic                       S_AXIL_arready =0   ;
  logic                       S_AXIL_arvalid =0   ;
  logic [ADDR_WIDTH-1:0]      S_AXIL_awaddr  =0   ;
  logic [2:0]                 S_AXIL_awprot  =0   ;
  logic                       S_AXIL_awready =0   ;
  logic                       S_AXIL_awvalid =0   ;
  logic                       S_AXIL_bready  =0   ;
  logic [1:0]                 S_AXIL_bresp   =0   ;
  logic                       S_AXIL_bvalid  =0   ;
  logic [AXIL_DWIDTH-1:0]     S_AXIL_rdata   =0   ;
  logic                       S_AXIL_rready  =0   ;
  logic [1:0]                 S_AXIL_rresp   =0   ;
  logic                       S_AXIL_rvalid  =0   ;
  logic [AXIL_DWIDTH-1:0]     S_AXIL_wdata   =0   ;
  logic                       S_AXIL_wready  =0   ;
  logic [(AXIL_DWIDTH/8)-1:0] S_AXIL_wstrb   ='1  ;
  logic                       S_AXIL_wvalid  =0   ;

  logic [ADDR_WIDTH-1:0]      M_AXIL_araddr  =0   ;
  logic [2:0]                 M_AXIL_arprot       ;
  logic                       M_AXIL_arready =0   ;
  logic                       M_AXIL_arvalid =0   ;
  logic [ADDR_WIDTH-1:0]      M_AXIL_awaddr  =0   ;
  logic [2:0]                 M_AXIL_awprot  =0   ;
  logic                       M_AXIL_awready =0   ;
  logic                       M_AXIL_awvalid =0   ;
  logic                       M_AXIL_bready  =0   ;
  logic [1:0]                 M_AXIL_bresp   =0   ;
  logic                       M_AXIL_bvalid  =0   ;
  logic [DATA_WIDTH-1:0]      M_AXIL_rdata   =0   ;
  logic                       M_AXIL_rready  =0   ;
  logic [1:0]                 M_AXIL_rresp   =0   ;
  logic                       M_AXIL_rvalid  =0   ;
  logic [DATA_WIDTH-1:0]      M_AXIL_wdata   =0   ;
  logic                       M_AXIL_wready  =0   ;
  logic [(DATA_WIDTH/8)-1:0]  M_AXIL_wstrb   ='1  ;
  logic                       M_AXIL_wvalid  =0   ;


  logic [31:0] S2MM_tdata='0 ;
  logic [ 3:0] S2MM_tkeep='0 ,S2MM_tdest='0;
  logic S2MM_tlast='0, S2MM_tready='0, S2MM_tvalid='0;
  logic [ 7:0] S2MM_tid='0;
  logic [15:0] S2MM_tuser='0;

  mcdma_bd_wrapper  mcdma_bd_wrapper_i (
    .M_AXIS_MM2S_tdata        (                 ),
    .M_AXIS_MM2S_tdest        (                 ),
    .M_AXIS_MM2S_tid          (                 ),
    .M_AXIS_MM2S_tkeep        (                 ),
    .M_AXIS_MM2S_tlast        (                 ),
//    .M_AXIS_MM2S_tready       ('1               ),
    .M_AXIS_MM2S_tuser        (                 ),
    .M_AXIS_MM2S_tvalid       (                 ),
    
    .S00_AXI_araddr     (S00_axi_araddr),
    .S00_AXI_arburst    (S00_axi_arburst),
    .S00_AXI_arcache    (S00_axi_arcache),
    .S00_AXI_arlen      (S00_axi_arlen),
    .S00_AXI_arlock     (S00_axi_arlock),
    .S00_AXI_arprot     (S00_axi_arprot),
    .S00_AXI_arqos      (S00_axi_arqos),
    .S00_AXI_arready    (S00_axi_arready),
    .S00_AXI_arsize     (S00_axi_arsize),
    .S00_AXI_arvalid    (S00_axi_arvalid),
    .S00_AXI_awaddr     (S00_axi_awaddr),
    .S00_AXI_awburst    (S00_axi_awburst),
    .S00_AXI_awcache    (S00_axi_awcache),
    .S00_AXI_awlen      (S00_axi_awlen),
    .S00_AXI_awlock     (S00_axi_awlock),
    .S00_AXI_awprot     (S00_axi_awprot),
    .S00_AXI_awqos      (S00_axi_awqos),
    .S00_AXI_awready    (S00_axi_awready),
    .S00_AXI_awsize     (S00_axi_awsize), 
    .S00_AXI_awvalid    (S00_axi_awvalid),
    .S00_AXI_bready     (S00_axi_bready),
    .S00_AXI_bresp      (S00_axi_bresp),
    .S00_AXI_bvalid     (S00_axi_bvalid),
    .S00_AXI_rdata      (S00_axi_rdata),
    .S00_AXI_rlast      (S00_axi_rlast),
    .S00_AXI_rready     (S00_axi_rready),
    .S00_AXI_rresp      (S00_axi_rresp),
    .S00_AXI_rvalid     (S00_axi_rvalid),
    .S00_AXI_wdata      (S00_axi_wdata),
    .S00_AXI_wlast      (S00_axi_wlast),
    .S00_AXI_wready     (S00_axi_wready),
    .S00_AXI_wstrb      (S00_axi_wstrb),
    .S00_AXI_wvalid     (S00_axi_wvalid),
    .S00_AXI_arid       ('0),
    .S00_AXI_aruser     ('0),
    .S00_AXI_awid       ('0),
    .S00_AXI_awuser     ('0),
    .S00_AXI_bid        (),
    .S00_AXI_rid        (),

    .S_AXI_araddr   (),
    .S_AXI_arburst  (),
    .S_AXI_arcache  (),
    .S_AXI_arlen    (),
    .S_AXI_arlock   (),
    .S_AXI_arprot   (),
    .S_AXI_arready  (),
    .S_AXI_arsize   (),
    .S_AXI_arvalid  (),
    .S_AXI_awaddr   (),
    .S_AXI_awburst  (),
    .S_AXI_awcache  (),
    .S_AXI_awlen    (),
    .S_AXI_awlock   (),
    .S_AXI_awprot   (),
    .S_AXI_awready  (),
    .S_AXI_awsize   (),
    .S_AXI_awvalid  (),
    .S_AXI_bready   (),
    .S_AXI_bresp    (),
    .S_AXI_bvalid   (),
    .S_AXI_rdata    (),
    .S_AXI_rlast    (),
    .S_AXI_rready   (),
    .S_AXI_rresp    (),
    .S_AXI_rvalid   (),
    .S_AXI_wdata    (),
    .S_AXI_wlast    (),
    .S_AXI_wready   (),
    .S_AXI_wstrb    (),
    .S_AXI_wvalid   (),
    .ext_reset_in   (rstn             ),
    .s_axi_aclk     (clk              )
  );


/*
    .S_AXIL_araddr            (S_AXIL_araddr    ),
    .S_AXIL_arready           (S_AXIL_arready   ),
    .S_AXIL_arvalid           (S_AXIL_arvalid   ),
    .S_AXIL_arprot            ('0),
    .S_AXIL_awaddr            (S_AXIL_awaddr    ),
    .S_AXIL_awready           (S_AXIL_awready   ),
    .S_AXIL_awvalid           (S_AXIL_awvalid   ),
    .S_AXIL_awprot            ('0),
    .S_AXIL_bready            (S_AXIL_bready    ),
    .S_AXIL_bresp             (S_AXIL_bresp     ),
    .S_AXIL_bvalid            (S_AXIL_bvalid    ),
    .S_AXIL_rdata             (S_AXIL_rdata     ),
    .S_AXIL_rready            (S_AXIL_rready    ),
    .S_AXIL_rresp             (S_AXIL_rresp     ),
    .S_AXIL_rvalid            (S_AXIL_rvalid    ),
    .S_AXIL_wdata             (S_AXIL_wdata     ),
    .S_AXIL_wready            (S_AXIL_wready    ),
    .S_AXIL_wvalid            (S_AXIL_wvalid    ),
    .S_AXIL_wstrb             ('1),
    .S_AXIS_S2MM_tdata        (S2MM_tdata       ),
    .S_AXIS_S2MM_tdest        (S2MM_tdest       ),
    .S_AXIS_S2MM_tid          (S2MM_tid         ),
    .S_AXIS_S2MM_tkeep        (S2MM_tkeep       ),
    .S_AXIS_S2MM_tlast        (S2MM_tlast       ),
    .S_AXIS_S2MM_tready       (S2MM_tready      ),
    .S_AXIS_S2MM_tuser        (S2MM_tuser       ),
    .S_AXIS_S2MM_tvalid       (S2MM_tvalid      ),
    .aclk                     (clk              ),
    .arstn                    (rstn             )
  );
*/

axi_dwidth_converter_axi4_64to128 axi_dwidth_converter_axi4_64to128_i (
  .s_axi_aclk      (clk),                   //input wire s_axi_aclk
  .s_axi_aresetn   (rstn),                  //input wire s_axi_aresetn
  
  .s_axi_awaddr    (m_axi_awaddr),         //input wire [39 : 0] s_axi_awaddr
  .s_axi_awlen     (m_axi_awlen),          //input wire [7 : 0] s_axi_awlen
  .s_axi_awsize    (m_axi_awsize),         //input wire [2 : 0] s_axi_awsize
  .s_axi_awburst   (m_axi_awburst),        //input wire [1 : 0] s_axi_awburst
  .s_axi_awlock    (m_axi_awlock),         //input wire [0 : 0] s_axi_awlock
  .s_axi_awcache   (m_axi_awcache),        //input wire [3 : 0] s_axi_awcache
  .s_axi_awprot    (m_axi_awprot),         //input wire [2 : 0] s_axi_awprot
  .s_axi_awregion  (m_axi_awregion),       //inputwire [3 : 0] s_axi_awregion
  .s_axi_awqos     (m_axi_awqos),          //input wire [3 : 0] s_axi_awqos
  .s_axi_awvalid   (m_axi_awvalid),        //input wire s_axi_awvalid
  .s_axi_awready   (m_axi_awready),        //output wire s_axi_awready
  .s_axi_wdata     (m_axi_wdata),          //input wire [63 : 0] s_axi_wdata
  .s_axi_wstrb     (m_axi_wstrb),          //input wire [7 : 0] s_axi_wstrb
  .s_axi_wlast     (m_axi_wlast),          //input wire s_axi_wlast
  .s_axi_wvalid    (m_axi_wvalid),         //input wire s_axi_wvalid
  .s_axi_wready    (m_axi_wready),         //output wire s_axi_wready
  .s_axi_bresp     (m_axi_bresp),          //output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid    (m_axi_bvalid),         //output wire s_axi_bvalid
  .s_axi_bready    (m_axi_bready),         //input wire s_axi_bready
  .s_axi_araddr    (m_axi_araddr),         //input wire [39 : 0] s_axi_araddr
  .s_axi_arlen     (m_axi_arlen),          //input wire [7 : 0] s_axi_arlen
  .s_axi_arsize    (m_axi_arsize),         //input wire [2 : 0] s_axi_arsize
  .s_axi_arburst   (m_axi_arburst),        //input wire [1 : 0] s_axi_arburst
  .s_axi_arlock    (m_axi_arlock),         //input wire [0 : 0] s_axi_arlock
  .s_axi_arcache   (m_axi_arcache),        //input wire [3 : 0] s_axi_arcache
  .s_axi_arprot    (m_axi_arprot),         //input wire [2 : 0] s_axi_arprot
  .s_axi_arregion  (m_axi_arregion),       //inputwire [3 : 0] s_axi_arregion
  .s_axi_arqos     (m_axi_arqos),          //input wire [3 : 0] s_axi_arqos
  .s_axi_arvalid   (m_axi_arvalid),        //input wire s_axi_arvalid
  .s_axi_arready   (m_axi_arready),        //output wire s_axi_arready
  .s_axi_rdata     (m_axi_rdata),          //output wire [63 : 0] s_axi_rdata
  .s_axi_rresp     (m_axi_rresp),          //output wire [1 : 0] s_axi_rresp
  .s_axi_rlast     (m_axi_rlast),          //output wire s_axi_rlast
  .s_axi_rvalid    (m_axi_rvalid),         //output wire s_axi_rvalid
  .s_axi_rready    (m_axi_rready),         //input wire s_axi_rready
  
  .m_axi_awaddr    (S00_axi_awaddr),         //output wire [39 : 0]   m_axi_awaddr
  .m_axi_awlen     (S00_axi_awlen),          //output wire [7 : 0]    m_axi_awlen
  .m_axi_awsize    (S00_axi_awsize),         //output wire [2 : 0]    m_axi_awsize
  .m_axi_awburst   (S00_axi_awburst),        //output wire [1 : 0]    m_axi_awburst
  .m_axi_awlock    (S00_axi_awlock),         //output wire [0 : 0]    m_axi_awlock
  .m_axi_awcache   (S00_axi_awcache),        //output wire [3 : 0]    m_axi_awcache
  .m_axi_awprot    (S00_axi_awprot),         //output wire [2 : 0]    m_axi_awprot
  .m_axi_awregion  (S00_axi_awregion),       //output wire [3 : 0]    m_axi_awregion
  .m_axi_awqos     (S00_axi_awqos),          //output wire [3 : 0]    m_axi_awqos
  .m_axi_awvalid   (S00_axi_awvalid),        //output wire            m_axi_awvalid
  .m_axi_awready   (S00_axi_awready),        //input wire             m_axi_awready
  .m_axi_wdata     (S00_axi_wdata),          //output wire [127 : 0]  m_axi_wdata
  .m_axi_wstrb     (S00_axi_wstrb),          //output wire [15 : 0]   m_axi_wstrb
  .m_axi_wlast     (S00_axi_wlast),          //output wire            m_axi_wlast
  .m_axi_wvalid    (S00_axi_wvalid),         //output wire            m_axi_wvalid
  .m_axi_wready    (S00_axi_wready),         //input wire             m_axi_wready
  .m_axi_bresp     (S00_axi_bresp),          //input wire [1 : 0]     m_axi_bresp
  .m_axi_bvalid    (S00_axi_bvalid),         //input wire             m_axi_bvalid
  .m_axi_bready    (S00_axi_bready),         //output wire            m_axi_bready
  .m_axi_araddr    (S00_axi_araddr),         //output wire [39 : 0]   m_axi_araddr
  .m_axi_arlen     (S00_axi_arlen),          //output wire [7 : 0]    m_axi_arlen
  .m_axi_arsize    (S00_axi_arsize),         //output wire [2 : 0]    m_axi_arsize
  .m_axi_arburst   (S00_axi_arburst),        //output wire [1 : 0]    m_axi_arburst
  .m_axi_arlock    (S00_axi_arlock),         //output wire [0 : 0]    m_axi_arlock
  .m_axi_arcache   (S00_axi_arcache),        //output wire [3 : 0]    m_axi_arcache
  .m_axi_arprot    (S00_axi_arprot),         //output wire [2 : 0]    m_axi_arprot
  .m_axi_arregion  (S00_axi_arregion),       //output wire [3 : 0]    m_axi_arregion
  .m_axi_arqos     (S00_axi_arqos),          //output wire [3 : 0]    m_axi_arqos
  .m_axi_arvalid   (S00_axi_arvalid),        //output wire            m_axi_arvalid
  .m_axi_arready   (S00_axi_arready),        //input wire             m_axi_arready
  .m_axi_rdata     (S00_axi_rdata),          //input wire [127 : 0]   m_axi_rdata
  .m_axi_rresp     (S00_axi_rresp),          //input wire [1 : 0]     m_axi_rresp
  .m_axi_rlast     (S00_axi_rlast),          //input wire             m_axi_rlast
  .m_axi_rvalid    (S00_axi_rvalid),         //input wire             m_axi_rvalid
  .m_axi_rready    (S00_axi_rready)          //output wire            m_axi_rready
);

axi_protocol_converter_0 axi_protocol_converter_i (
  .aclk            (clk),                    
  .aresetn         (rstn),              
  .s_axi_awaddr    (M_AXIL_awaddr),
  .s_axi_awprot    (M_AXIL_awprot),
  .s_axi_awvalid   (M_AXIL_awvalid),
  .s_axi_awready   (M_AXIL_awready),
  .s_axi_wdata     (M_AXIL_wdata),
  .s_axi_wstrb     (M_AXIL_wstrb),
  .s_axi_wvalid    (M_AXIL_wvalid),
  .s_axi_wready    (M_AXIL_wready),
  .s_axi_bresp     (M_AXIL_bresp),
  .s_axi_bvalid    (M_AXIL_bvalid),
  .s_axi_bready    (M_AXIL_bready),
  .s_axi_araddr    (M_AXIL_araddr),
  .s_axi_arprot    (M_AXIL_arprot),
  .s_axi_arvalid   (M_AXIL_arvalid),
  .s_axi_arready   (M_AXIL_arready),
  .s_axi_rdata     (M_AXIL_rdata),
  .s_axi_rresp     (M_AXIL_rresp),
  .s_axi_rvalid    (M_AXIL_rvalid),
  .s_axi_rready    (M_AXIL_rready),
  .m_axi_awaddr    (m_axi_awaddr      ),
  .m_axi_awlen     (m_axi_awlen       ),
  .m_axi_awsize    (m_axi_awsize      ),
  .m_axi_awburst   (m_axi_awburst     ),
  .m_axi_awlock    (m_axi_awlock      ),
  .m_axi_awcache   (m_axi_awcache     ),
  .m_axi_awprot    (m_axi_awprot      ),
  .m_axi_awregion  (m_axi_awregion    ),
  .m_axi_awqos     (m_axi_awqos       ),
  .m_axi_awvalid   (m_axi_awvalid     ),
  .m_axi_awready   (m_axi_awready     ),
  .m_axi_wdata     (m_axi_wdata       ),
  .m_axi_wstrb     (m_axi_wstrb       ),
  .m_axi_wlast     (m_axi_wlast       ),
  .m_axi_wvalid    (m_axi_wvalid      ),
  .m_axi_wready    (m_axi_wready      ),
  .m_axi_bresp     (m_axi_bresp       ),
  .m_axi_bvalid    (m_axi_bvalid      ),
  .m_axi_bready    (m_axi_bready      ),
  .m_axi_araddr    (m_axi_araddr      ),
  .m_axi_arlen     (m_axi_arlen       ),
  .m_axi_arsize    (m_axi_arsize      ),
  .m_axi_arburst   (m_axi_arburst     ),
  .m_axi_arlock    (m_axi_arlock      ),
  .m_axi_arcache   (m_axi_arcache     ),
  .m_axi_arprot    (m_axi_arprot      ),
  .m_axi_arregion  (m_axi_arregion    ),
  .m_axi_arqos     (m_axi_arqos       ),
  .m_axi_arvalid   (m_axi_arvalid     ),
  .m_axi_arready   (m_axi_arready     ),
  .m_axi_rdata     (m_axi_rdata       ),
  .m_axi_rresp     (m_axi_rresp       ),
  .m_axi_rlast     (m_axi_rlast       ),
  .m_axi_rvalid    (m_axi_rvalid      ),
  .m_axi_rready    (m_axi_rready      )
);

  

axi_dwidth_converter_0 axi_dwidth_converter_i (
  .s_axi_aclk     (clk), 
  .s_axi_aresetn  (rstn), 
  .s_axi_awaddr   (m_axil_if.awaddr      ),// input wire [39 : 0] s_axi_awaddr       S_AXIL
  .s_axi_awprot   (m_axil_if.awprot      ),// input wire [2 : 0] s_axi_awprot
  .s_axi_awvalid  (m_axil_if.awvalid     ),// input wire s_axi_awvalid
  .s_axi_awready  (m_axil_if.awready     ),// output wire s_axi_awready
  .s_axi_wdata    (m_axil_if.wdata       ),// input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb    (m_axil_if.wstrb       ),// input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid   (m_axil_if.wvalid      ),// input wire s_axi_wvalid
  .s_axi_wready   (m_axil_if.wready      ),// output wire s_axi_wready
  .s_axi_bresp    (m_axil_if.bresp       ),// output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid   (m_axil_if.bvalid      ),// output wire s_axi_bvalid
  .s_axi_bready   (m_axil_if.bready      ),// input wire s_axi_bready
  .s_axi_araddr   (m_axil_if.araddr      ),// input wire [39 : 0] s_axi_araddr
  .s_axi_arprot   (m_axil_if.arprot      ),// input wire [2 : 0] s_axi_arprot
  .s_axi_arvalid  (m_axil_if.arvalid     ),// input wire s_axi_arvalid
  .s_axi_arready  (m_axil_if.arready     ),// output wire s_axi_arready
  .s_axi_rdata    (m_axil_if.rdata       ),// output wire [31 : 0] s_axi_rdata
  .s_axi_rresp    (m_axil_if.rresp       ),// output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid   (m_axil_if.rvalid      ),// output wire s_axi_rvalid
  .s_axi_rready   (m_axil_if.rready      ),// input wire s_axi_rready
  
  .m_axi_awaddr   (M_AXIL_awaddr      ),// output wire [39 : 0] m_axi_awaddr
  .m_axi_awprot   (M_AXIL_awprot      ),// output wire [2 : 0] m_axi_awprot
  .m_axi_awvalid  (M_AXIL_awvalid     ),// output wire m_axi_awvalid
  .m_axi_awready  (M_AXIL_awready     ),// input wire m_axi_awready
  .m_axi_wdata    (M_AXIL_wdata       ),// output wire [63 : 0] m_axi_wdata
  .m_axi_wstrb    (M_AXIL_wstrb       ),// output wire [7 : 0] m_axi_wstrb
  .m_axi_wvalid   (M_AXIL_wvalid      ),// output wire m_axi_wvalid
  .m_axi_wready   (M_AXIL_wready      ),// input wire m_axi_wready
  .m_axi_bresp    (M_AXIL_bresp       ),// input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid   (M_AXIL_bvalid      ),// input wire m_axi_bvalid
  .m_axi_bready   (M_AXIL_bready      ),// output wire m_axi_bready
  .m_axi_araddr   (M_AXIL_araddr      ),// output wire [39 : 0] m_axi_araddr
  .m_axi_arprot   (M_AXIL_arprot      ),// output wire [2 : 0] m_axi_arprot
  .m_axi_arvalid  (M_AXIL_arvalid     ),// output wire m_axi_arvalid
  .m_axi_arready  (M_AXIL_arready     ),// input wire m_axi_arready
  .m_axi_rdata    (M_AXIL_rdata       ),// input wire [63 : 0] m_axi_rdata
  .m_axi_rresp    (M_AXIL_rresp       ),// input wire [1 : 0] m_axi_rresp
  .m_axi_rvalid   (M_AXIL_rvalid      ),// input wire m_axi_rvalid
  .m_axi_rready   (M_AXIL_rready      )// output wire m_axi_rready
);

  axil_if #(
    .DATA_WIDTH (AXIL_DWIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
  ) m_axil_if (
    .aclk       (clk),
    .aresetn    (rstn)
  );

  axil_stim_dma  # (
    .DATA_WIDTH (AXIL_DWIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
  ) axil_stim_dma_i (
    .start      (1'b1),
    .done       (axil_done),
    .m_axil_if  (m_axil_if)
  );

//  axil_stim_dma  # (
//    .DATA_WIDTH (AXIL_DWIDTH),
//    .ADDR_WIDTH (ADDR_WIDTH)
//  ) axil_stim_dma_i (
//    .start            (1'b1),
//    .done             (axil_done),
//    .M_AXI_aclk       (clk),
//    .M_AXI_aresetn    (rstn),
//    .M_AXI_araddr     (S_AXIL_araddr      ),
//    .M_AXI_arprot     (S_AXIL_arprot      ),
//    .M_AXI_arready    (S_AXIL_arready     ),
//    .M_AXI_arvalid    (S_AXIL_arvalid     ),
//    .M_AXI_awaddr     (S_AXIL_awaddr      ),
//    .M_AXI_awprot     (S_AXIL_awprot      ),
//    .M_AXI_awready    (S_AXIL_awready     ),
//    .M_AXI_awvalid    (S_AXIL_awvalid     ),
//    .M_AXI_bready     (S_AXIL_bready      ),
//    .M_AXI_bresp      (S_AXIL_bresp       ),
//    .M_AXI_bvalid     (S_AXIL_bvalid      ),
//    .M_AXI_rdata      (S_AXIL_rdata       ),
//    .M_AXI_rready     (S_AXIL_rready      ),
//    .M_AXI_rresp      (S_AXIL_rresp       ),
//    .M_AXI_rvalid     (S_AXIL_rvalid      ),
//    .M_AXI_wdata      (S_AXIL_wdata       ),
//    .M_AXI_wready     (S_AXIL_wready      ),
//    .M_AXI_wstrb      (S_AXIL_wstrb       ),
//    .M_AXI_wvalid     (S_AXIL_wvalid      )
//  );

  logic start=0;

//  axis_stim  # (
//    .DATA_WIDTH	    (32),
//    .FRAME_LENGTH   (16),
//    .NUM_FRAMES     (2),
//    .CNTR_WIDTH     (4),
//    .FIXED_DATA     (28'h666A500),
//    .FRAME_DELAY    (1000ns)
//  ) axis_stim_i (
//    .clk            (clk),
//    .start          (start),
//    .M_AXIS_tdata   (S2MM_tdata ),
//    .M_AXIS_tdest   (S2MM_tdest ),
//    .M_AXIS_tkeep   (S2MM_tkeep ),
//    .M_AXIS_tlast   (S2MM_tlast ),
//    .M_AXIS_tready  (S2MM_tready),
//    .M_AXIS_tvalid  (S2MM_tvalid)
//  );

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------


initial begin 
  wait(rst==0);
//  #200ns;tready=1;
  wait(axil_done == 1);
  #20ns;start_en;
end


task start_en;
  begin 
    @(posedge clk); start <= 1;
    @(posedge clk); start <= 0;
  end 
endtask
  

endmodule